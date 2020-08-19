locals {
  _instance_conf_list = flatten([
    for _conf in var.gce_conf : {
      name          = _conf.name
      machine_type  = _conf.machine_type
      zone          = _conf.zone
      tags          = _conf.tags
      network       = _conf.network
      boot_disk     = _conf.boot_disk
      access_config = _conf.access_config
      service_account = {
        email = data.google_service_account.main[_conf.service_account.email].email
        scopes = _conf.service_account.scopes
      }

      scheduling = flatten([
        for _s in local._sch : {
          on_host_maintenance = _s.on_host_maintenance
          automatic_restart   = _s.automatic_restart
          preemptible         = _s.preemptible
        } if _s.gce_name == _conf.name
      ])
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
      name   = _conf.network
      region = _conf.region
    } if _conf.gce_enable
  ])

  _sch = flatten([
    for _conf in var.gce_conf : [
      for _s in local._sch_tmp : _s
    ] if _conf.preemptible_enable
  ])

  _sch_tmp = flatten([
    [
      for _conf in var.gce_conf : [
        for _sche in var.scheduling : {
          gce_name            = _sche.gce_name
          automatic_restart   = _sche.automatic_restart
          on_host_maintenance = _sche.on_host_maintenance
          preemptible         = false
        } if _sche.gce_name == _conf.name
      ] if ! _conf.preemptible_enable && var.scheduling != null
    ],
    flatten([
      for _conf in var.gce_conf : [
        for _tmp in local._pre_tmp : _tmp
      ] if _conf.preemptible_enable
    ])
  ])

  _pre_tmp = flatten([
    for _conf in var.gce_conf : [
      {
        gce_name            = _conf.name
        preemptible         = true
        automatic_restart   = false
        on_host_maintenance = "TERMINATE"
      }
    ] if _conf.preemptible_enable
  ])
}

resource "google_compute_instance" "main" {
  depends_on = [ google_compute_disk.main]
  for_each = { for v in local._instance_conf_list : v.name => v }

  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone
  tags         = each.value.tags

  boot_disk {
    auto_delete = each.value.boot_disk.auto_delete
    source      = google_compute_disk.main[each.value.name].self_link
  }

  dynamic "scheduling" {
    for_each = each.value.scheduling
    content {
      preemptible = scheduling.value.preemptible
      automatic_restart = scheduling.value.automatic_restart
      on_host_maintenance = scheduling.value.on_host_maintenance
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.main[each.value.network].self_link

    dynamic "access_config" {
      for_each = each.value.access_config
      content {

      }
    }
  }

  service_account {
    email = each.value.service_account.email
    scopes = each.value.service_account.scopes
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
