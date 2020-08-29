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
        name    = _subnet.name
        cidr    = _subnet.cidr
        region  = _subnet.region
        network = _conf.vpc_network_conf.name
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

  name          = each.value.name
  network       = google_compute_network.main[each.value.network].self_link
  ip_cidr_range = each.value.cidr
  region        = each.value.region
}
