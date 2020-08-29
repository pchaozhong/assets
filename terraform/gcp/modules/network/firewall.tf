locals {
  _fw_egress_list = flatten([
    for _conf in var.network_conf : [
      for _fw_conf in _conf.firewall_egress_conf : {
        name               = _fw_conf.name
        network            = _conf.vpc_network_conf.name
        priority           = _fw_conf.priority
        destination_ranges = _fw_conf.destination_ranges
        target_tags        = _fw_conf.target_tags
        allow_rules        = _fw_conf.allow_rules
        deny_rules         = _fw_conf.deny_rules
        log_config         = lookup(_fw_conf.opt_conf, "log_config", false)
        metadata           = lookup(_fw_conf.opt_conf, "metadata", "INCLUDE_ALL_METADATA")
        description        = lookup(_fw_conf.opt_conf, "description", null)
      }
    ] if _conf.firewall_egress_enable && _conf.vpc_network_enable
  ])

  _fw_ingress_list = flatten([
    for _conf in var.network_conf : [
      for _fw_conf in _conf.firewall_ingress_conf : {
        name          = _fw_conf.name
        network       = _conf.vpc_network_conf.name
        priority      = _fw_conf.priority
        source_ranges = _fw_conf.source_ranges
        target_tags   = _fw_conf.target_tags
        allow_rules   = _fw_conf.allow_rules
        deny_rules    = _fw_conf.deny_rules
        log_config    = lookup(_fw_conf.opt_conf, "log_config", false)
        metadata           = lookup(_fw_conf.opt_conf, "metadata", "INCLUDE_ALL_METADATA")
        description   = lookup(_fw_conf.opt_conf, "description", null)
      }
    ] if _conf.firewall_ingress_enable && _conf.vpc_network_enable
  ])
}

resource "google_compute_firewall" "main_egress" {
  for_each = { for v in local._fw_egress_list : v.name => v }

  direction = "EGRESS"
  name      = each.value.name
  network   = google_compute_network.main[each.value.network].self_link
  priority  = each.value.priority

  destination_ranges = each.value.destination_ranges
  target_tags        = each.value.target_tags
  description        = each.value.description

  dynamic "allow" {
    for_each = each.value.allow_rules
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = each.value.deny_rules
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }

  dynamic "log_config" {
    for_each = each.value.log_config ? [{
      metadata = each.value.metadata
    }] : []
    content {
      metadata = log_config.value.metadata
    }
  }
}

resource "google_compute_firewall" "main_igress" {
  for_each = { for v in local._fw_ingress_list : v.name => v }

  direction = "INGRESS"
  name      = each.value.name
  network   = google_compute_network.main[each.value.network].self_link
  priority  = each.value.priority

  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags
  description   = each.value.description

  dynamic "allow" {
    for_each = each.value.allow_rules
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = each.value.deny_rules
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }

  dynamic "log_config" {
    for_each = each.value.log_config ? [{
      metadata = each.value.metadata
    }] : []
    content {
      metadata = log_config.value.metadata
    }
  }
}
