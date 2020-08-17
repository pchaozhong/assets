locals {
  _instance_conf_list = flatten([
    for _conf in var.gce_conf : {
      name          = _conf.name
      machine_type  = _conf.machine_type
      zone          = _conf.zone
      tags          = _conf.tags
      network       = _conf.network
      boot_disk     = _conf.boot_disk
      access_config = [for _acc in _conf.access_config : _acc if _acc.access_config_enable]
      scheduling    = [for _sc in _conf.scheduling : _sc if _sc.scheduling_enable]
    } if _conf.gce_enable
  ])

  _boot_disk_conf_list = flatten([
    for _conf in var.gce_conf : {
      gce_name = _conf.name
      name     = join("-", [_conf.name, "boot-disk"])
      size     = _conf.boot_disk.size
      type     = _conf.boot_disk.type
      image    = _conf.boot_disk.image
      zone     = _conf.zone
    } if _conf.gce_enable
  ])

  _nw_list = flatten([
    for _conf in var.gce_conf : {
      name = _conf.network
      region = _conf.region
    } if _conf.gce_enable
  ])
}

resource "google_compute_instance" "main" {
  for_each = { for v in local._instance_conf_list : v.name => v }

  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone
  tags         = each.value.tags

  boot_disk {
    auto_delete = each.value.boot_disk.auto_delete
    source      = google_compute_disk.main[each.value.name].self_link
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.main[each.value.network].self_link

    dynamic "access_config" {
      for_each = each.value.access_config
      content {

      }
    }
  }

  dynamic "scheduling" {
    for_each = each.value.scheduling
    content {
      preemptible         = scheduling.value.preemptible
      on_host_maintenance = scheduling.value.on_host_maintenance
      automatic_restart   = scheduling.value.automatic_restart
    }
  }
}

resource "google_compute_disk" "main" {
  for_each = { for v in local._boot_disk_conf_list : v.gce_name => v }

  name  = each.value.name
  size  = each.value.size
  type  = each.value.type
  zone  = each.value.zone
  image = each.value.image
}
