locals {
  _instance_conf_list = flatten([
    for _conf in var.gce_conf : {
      name                    = _conf.name
      machine_type            = _conf.machine_type
      zone                    = _conf.zone
      tags                    = _conf.tags
      subnetwork              = _conf.subnetwork
      metadata_startup_script = lookup(_conf.opt_conf, "metadata_startup_script", null)
      auto_delete             = lookup(_conf.boot_disk.opt_conf, "auto_delete", false)
      device_name             = lookup(_conf.boot_disk.opt_conf, "device_name", null)
      mode                    = lookup(_conf.boot_disk.opt_conf, "mode", "READ_WRITE")
      disk_encryption_key_raw = lookup(_conf.boot_disk.opt_conf, "disk_encryption_key_raw", null)
      scheduling              = lookup(_conf.opt_conf, "scheduling", false)
      preemptible             = lookup(_conf.opt_conf, "preemptible", false)
      automatic_restart       = lookup(_conf.opt_conf, "automatic_restart", false)
      on_host_maintenance     = lookup(_conf.opt_conf, "on_host_maintenance", "TERMINATE")
      access_config           = lookup(_conf.opt_conf, "access_config", true)
      nat_ip                  = lookup(_conf.opt_conf, "nat_ip", null)
      public_ptr_domain_name  = lookup(_conf.opt_conf, "public_ptr_domain_name", null)
      network_tier            = lookup(_conf.opt_conf, "network_tier", null)
      service_account_enable  = lookup(_conf.opt_conf, "service_account_enable", true)
      service_account = {
        email  = data.google_service_account.main[_conf.service_account.email].email
        scopes = _conf.service_account.scopes
      }
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
}

resource "google_compute_instance" "main" {
  depends_on = [google_compute_disk.main]
  for_each   = { for v in local._instance_conf_list : v.name => v }

  name                    = each.value.name
  machine_type            = each.value.machine_type
  zone                    = each.value.zone
  tags                    = each.value.tags
  metadata_startup_script = each.value.metadata_startup_script

  boot_disk {
    auto_delete             = each.value.auto_delete
    device_name             = each.value.device_name
    mode                    = each.value.mode
    disk_encryption_key_raw = each.value.disk_encryption_key_raw
    source                  = google_compute_disk.main[each.value.name].self_link
  }

  dynamic "scheduling" {
    for_each = each.value.scheduling || each.value.preemptible ? [{
      preemptible         = each.value.preemptible
      automatic_restart   = each.value.automatic_restart
      on_host_maintenance = each.value.on_host_maintenance
    }] : []
    content {
      preemptible         = scheduling.value.preemptible
      automatic_restart   = scheduling.value.automatic_restart
      on_host_maintenance = scheduling.value.on_host_maintenance
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.main[each.value.subnetwork].self_link

    dynamic "access_config" {
      for_each = each.value.access_config ? [{
        nat_ip                 = each.value.nat_ip
        public_ptr_domain_name = each.value.public_ptr_domain_name
        network_tier           = each.value.network_tier
      }] : []
      content {
        nat_ip                 = access_config.value.nat_ip
        public_ptr_domain_name = access_config.value.public_ptr_domain_name
        network_tier           = access_config.value.network_tier
      }
    }
  }

  dynamic "service_account" {
    for_each = each.value.service_account_enable ? [{
      email  = each.value.service_account.email
      scopes = each.value.service_account.scopes
    }] : []
    content {
      email  = service_account.value.email
      scopes = service_account.value.scopes
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
