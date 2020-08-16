locals {
  _route_conf_list = flatten([
    for _conf in var.network_conf : [
      for _route_conf in _conf.route_conf : {
        name             = _route_conf.name
        network          = _conf.vpc_network_conf.name
        dest_range       = _route_conf.dest_range
        priority         = _route_conf.priority
        tags             = _route_conf.tags
        next_hop_gateway = _route_conf.next_hop_gateway
      }
    ] if _conf.route_enable && _conf.vpc_network_enable
  ])
}

resource "google_compute_route" "main" {
  for_each = { for v in local._route_conf_list : v.name => v }

  name             = each.value.name
  dest_range       = each.value.dest_range
  network          = google_compute_network.main[each.value.network].self_link
  priority         = each.value.priority
  tags             = each.value.tags
  next_hop_gateway = each.value.next_hop_gateway
}
