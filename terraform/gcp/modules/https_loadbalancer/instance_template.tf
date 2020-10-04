locals {
  _template_conf = flatten([
    for _conf in var.https_loadbalancer_conf.instance_template_conf : _conf if var.https_loadbalancer_conf.enable && _conf.enable
  ])
}

resource "google_compute_instance_template" "main" {
  for_each = { for v in local._template_conf : v.name_prefix => v }

  name_prefix  = each.value.name_prefix
  machine_type = each.value.machine_type

  network_interface {
    subnetwork = data.google_compute_subnetwork.main[each.value.subnetwork].self_link

    dynamic "access_config" {
      for_each = lookup(each.value.opt_conf, "access_config", true) ? [{
        nat_ip       = lookup(each.value.opt_conf, "nat_ip", null)
        network_tier = lookup(each.value.opt_conf, "network_tier", null)
      }] : []
      content {
        nat_ip       = access_config.value.nat_ip
        network_tier = access_config.value.network_tier
      }
    }
  }

  dynamic "service_account" {
    for_each = lookup(each.value.opt_conf, "service_account", true) ? [{
      email  = each.value.email
      scopes = each.value.scopes
    }] : []
    content {
      email  = data.google_service_account.main[service_account.value.email].email
      scopes = service_account.value.scopes
    }
  }

  dynamic "scheduling" {
    for_each = lookup(each.value.opt_conf, "scheduling", false) ? [{
      automatic_restart   = lookup(each.value.opt_conf, "automatic_restart", null)
      on_host_maintenance = lookup(each.value.opt_conf, "on_host_maintenance", null)
      preemptible         = lookup(each.value.opt_conf, "preemptible", null)
      node_affinities     = lookup(each.value.opt_conf, "node_affinities", false)
    }] : []
    content {
      automatic_restart   = scheduling.value.automatic_restart
      on_host_maintenance = scheduling.value.on_host_maintenance
      preemptible         = scheduling.value.preemptible
    }
  }

  disk {
    source_image = each.value.source_image
    disk_size_gb = each.value.disk_size_gb
    auto_delete  = lookup(each.value.opt_conf, "auto_delete", true)
    boot         = lookup(each.value.opt_conf, "boot", true)
    disk_type    = lookup(each.value.opt_conf, "disk_type", "pd-ssd")
    mode         = lookup(each.value.opt_conf, "mode", "READ_WRITE")
  }
}
