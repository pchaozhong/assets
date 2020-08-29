locals {
  _network_conf = flatten([
    for _conf in var.network_conf : {
      name                            = _conf.vpc_network_conf.name
      auto_create_subnetworks         = _conf.vpc_network_conf.auto_create_subnetworks
      delete_default_routes_on_create = lookup(_conf.vpc_network_conf.opt_conf, "delete_default_routes_on_create", null)
      routing_mode                    = lookup(_conf.vpc_network_conf.opt_conf, "routing_mode", "REGIONAL")
      description                     = lookup(_conf.vpc_network_conf.opt_conf, "description", null)
    } if _conf.vpc_network_enable
  ])

  _subnet_conf = flatten([
    for _conf in var.network_conf : [
      for _subnet in _conf.subnetwork : {
        name               = _subnet.name
        cidr               = _subnet.cidr
        region             = _subnet.region
        network            = _conf.vpc_network_conf.name
        purpose            = lookup(_subnet.opt_conf, "purpose", null)
        range_name         = lookup(_subnet.opt_conf, "range_name", null)
        description        = lookup(_subnet.opt_conf, "description", null)
        ip_cidr_range      = lookup(_subnet.opt_conf, "ip_cidr_range", null)
        secondary_ip_range = lookup(_subnet.opt_conf, "secondary_ip_range", false)
      }
    ] if _conf.subnetwork_enable && _conf.vpc_network_enable
  ])
}

resource "google_compute_network" "main" {
  for_each = { for v in local._network_conf : v.name => v }

  name                            = each.value.name
  auto_create_subnetworks         = each.value.auto_create_subnetworks
  description                     = each.value.description
  delete_default_routes_on_create = each.value.delete_default_routes_on_create
  routing_mode                    = each.value.routing_mode
}

resource "google_compute_subnetwork" "main" {
  for_each = { for v in local._subnet_conf : v.name => v }
  provider = "google-beta"

  name          = each.value.name
  network       = google_compute_network.main[each.value.network].self_link
  ip_cidr_range = each.value.cidr
  region        = each.value.region
  description   = each.value.description
  purpose       = each.value.purpose

  dynamic "secondary_ip_range" {
    for_each = lookup(each.value, "secondary_ip_range", false) ? [{
      range_name    = each.value.range_name
      ip_cidr_range = each.value.ip_cidr_range
    }] : []
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}
