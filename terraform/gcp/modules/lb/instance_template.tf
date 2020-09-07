locals {
  _instance_template = flatten([
    for _conf in var.lb_conf : [
      for _ist_tmp in _conf.instance_template : {
        name_prefix           = _conf.instance_template
        machine_type          = _ist_tmp.machine_type
        source_image          = _ist_tmp.source_image
        auto_delete           = _ist_tmp.auto_delete
        access_config         = _ist_tmp.access_config
        create_before_destroy = _ist_tmp.create_before_destroy
      }
    ]
  ])
}

resource "google_compute_instance_template" "main" {
  for_each = { for v in local._instance_template : v.name_prefix => v }

  name_prefix          = each.value.name_prefix
  machine_type         = each.value.machine_type
  tags                 = each.value.tags
  region               = each.value.region
  instance_description = lookup(each.value.opt_var, "instance_description", null)
  project              = lookup(each.value.opt_var, "project", terraform.workspace)

  dynamic "service_account" {
    for_each = lookup(each.value.opt_var, "service_account", false) ? [{
      email  = lookup(email.value.opt_var, "email", null)
      scopes = each.value.scopes
    }] : []
    content {
      email  = service_account.value.email != null ? data.service_account.main[service_account.value.email].email : null
      scopes = var.scopes
    }
  }

  dynamic "guest_accelerator" {
    for_each = lookup(each.value.opt_var, "guest_accelerator", false) ? [{
      type  = each.value.type
      count = each.value.count
    }] : []
    content {
      type  = guest_accelerator.value.type
      count = guest_accelerator.value.count
    }
  }


  min_cpu_platform = lookup(each.value.opt_var, "", null)
  enable_display   = lookup(each.value.opt_var, "", null)

  disk {
    source_image = each.value.source_image
    auto_delete  = lookup(each.value.opt_var, "auto_delete", true)
    device_name  = lookup(each.value.opt_var, "device_name", null)
    disk_name    = lookup(each.value.opt_var, "disk_name", null)
    interface    = lookup(each.value.opt_var, "interface", null)
    mode         = lookup(each.value.opt_var, "mode", null)
    disk_type    = lookup(each.value.opt_var, "disk_type", null)
    disk_size_gb = lookup(each.value.opt_var, "disk_size_gb", null)
    type         = lookup(each.value.opt_var, "type", null)
  }

  network_interface {
    network        = lookup(each.value.opt_var, "network", null)
    subnetwork     = lookup(each.value.opt_var, "subnetwork", null)
    network_ip     = lookup(each.value.opt_var, "network_ip", null)
    alias_ip_range = lookup(each.value.opt_var, "alias_ip_range", null)


    dynamic "access_config" {
      for_each = lookup(each.value.opt_var, "access_config", false) ? [{
        nat_ip       = lookup(each.value.opt_var, "nat_ip", null)
        network_tier = lookup(each.value.opt_var, "network_tier", null)
      }] : []
      content {
        nat_ip       = access_config.value.nat_ip
        network_tier = access_config.value.network_tier
      }
    }

    dynamic "alias_ip_range" {
      for_each = lookup(each.value.opt_var, "access_config", false) ? [{
        ip_cidr_range         = lookup(each.value.opt_var, "ip_cidr_range", null)
        subnetwork_range_name = lookup(each.value.opt_var, "subnetwork_range_name", null)
      }] : []
      content {
        ip_cidr_range         = alias_ip_range.value.ip_cidr_range
        subnetwork_range_name = alias_ip_range.value.subnetwork_range_name
      }
    }
  }

  dynamic "schduling" {
    for_each = lookup(each.value.opt_var, "schduling", false) ? [{
      automatic_restart   = lookup(each.value.opt_var, "automatic_restart", null)
      on_host_maintenance = lookup(each.value.opt_var, "on_host_maintenance", null)
      preemtible          = lookup(each.value.opt_var, "preemtible", false)
      node_affinities     = lookup(each.value.opt_var, "node_affinities", false)
    }] : []
    content {
      automatic_restart   = schduling.value.automatic_restart
      on_host_maintenance = schduling.value.on_host_maintenance
      preemtible          = schduling.value.preemtible

      dynamic "node_affinities" {
        for_each = schduling.value.node_affinities ? [{
          key      = each.value.key
          operator = each.value.operator
          value    = each.value.value
        }] : []
        content {
          key      = node_affinities.value.key
          operator = node_affinities.value.operator
          value    = node_affinities.value.value
        }
      }
    }
  }


  dynamic "shielded_instance_config" {
    for_each = lookup(each.value.opt_var, "shielded_instance_config", false) ? [{
      enable_secure_boot          = lookup(each.value.opt_var, "enable_secure_boot", null)
      enable_vtpm                 = lookup(each.value.opt_var, "enable_vtpm", null)
      enable_integrity_monitoring = lookup(each.value.opt_var, "enable_integrity_monitoring", null)
    }] : []
    content {
      enable_secure_boot          = shielded_instance_config.value.enable_secure_boot
      enable_vtpm                 = shielded_instance_config.value.enable_vtpm
      enable_integrity_monitoring = shielded_instance_config.value.enable_integrity_monitoring
    }
  }

  dynamic "lifecycle" {
    for_each = lookup(each.value.opt_var, "lifecycle", false) ? [{
      create_before_destroy = lookup(each.value.opt_var, "create_before_destroy", null)
      prevent_destroy       = lookup(each.value.opt_var, "prevent_destroy", false)
      ignore_changes        = lookup(each.value.opt_var, "ignore_changes", null)
    }] : []
    content {
      create_before_destroy = lifecycle.value.create_before_destroy
      prevent_destroy       = lifecycle.value.prevent_destroy
      ignore_changes        = lifecycle.value.ignore_changes
    }
  }
}
