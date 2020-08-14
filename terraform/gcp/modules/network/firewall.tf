resource "google_compute_firewall" "main_egress" {
  for_each = { for v in var.firewall_egress_conf : v.name => v }

  direction      = "EGRESS"
  name           = each.value.name
  network        = each.value.network
  priority       = each.value.priority
  enable_logging = each.value.enable_logging

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
  for_each = { for v in var.firewall_ingress_conf : v.name => v }

  direction      = "INGRESS"
  name           = each.value.name
  network        = each.value.network
  priority       = each.value.priority
  enable_logging = each.value.enable_logging

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
