locals {
  _fw_egress_list = flatten([
    for _conf in var.network_conf : [
      for _fw_conf in _conf.firewall_egress_conf : {
        name               = _fw_conf.name
        network            = _conf.vpc_network_conf.name
        priority           = _fw_conf.priority
        # enable_logging     = _fw_conf.enable_logging
        destination_ranges = _fw_conf.destination_ranges
        target_tags        = _fw_conf.target_tags
        allow_rules        = _fw_conf.allow_rules
        deny_rules         = _fw_conf.deny_rules
      }
    ] if _conf.firewall_egress_enable && _conf.vpc_network_enable
  ])

  _fw_ingress_list = flatten([
    for _conf in var.network_conf : [
      for _fw_conf in _conf.firewall_ingress_conf : {
        name           = _fw_conf.name
        network        = _conf.vpc_network_conf.name
        priority       = _fw_conf.priority
        # enable_logging = _fw_conf.enable_logging
        source_ranges  = _fw_conf.source_ranges
        target_tags    = _fw_conf.target_tags
        allow_rules    = _fw_conf.allow_rules
        deny_rules     = _fw_conf.deny_rules
      }
    ] if _conf.firewall_ingress_enable && _conf.vpc_network_enable
  ])
}

resource "google_compute_firewall" "main_egress" {
  for_each = { for v in local._fw_egress_list : v.name => v }

  direction      = "EGRESS"
  name           = each.value.name
  network        = google_compute_network.main[each.value.network].self_link
  priority       = each.value.priority
  # enable_logging = each.value.enable_logging

  destination_ranges = each.value.destination_ranges
  target_tags        = each.value.target_tags

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

}

resource "google_compute_firewall" "main_igress" {
  for_each = { for v in local._fw_ingress_list : v.name => v }

  direction      = "INGRESS"
  name           = each.value.name
  network        = google_compute_network.main[each.value.network].self_link
  priority       = each.value.priority
  # enable_logging = each.value.enable_logging

  source_ranges = each.value.source_ranges
  target_tags   = each.value.target_tags

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
}
