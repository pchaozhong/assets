locals {
  _route_conf_list = flatten([
    for _conf in var.network_conf : [
      for _route_conf in _conf.route_conf : {
        name                   = _route_conf.name
        network                = _conf.vpc_network_conf.name
        dest_range             = _route_conf.dest_range
        tags                   = _route_conf.tags
        priority               = lookup(_route_conf.opt_conf, "priority", null)
        description            = lookup(_route_conf.opt_conf, "description", null)
        next_hop_gateway       = lookup(_route_conf.opt_conf, "next_hop_gateway", null)
        next_hop_instance      = lookup(_route_conf.opt_conf, "next_hop_instance", null)
        next_hop_ip            = lookup(_route_conf.opt_conf, "next_hop_ip", null)
        next_hop_ilb           = lookup(_route_conf.opt_conf, "next_hop_ilb", null)
        next_hop_vpn_tunnel    = lookup(_route_conf.opt_conf, "next_hop_vpn_tunnel", null)
        next_hop_instance_zone = lookup(_route_conf.opt_conf, "next_hop_instance_zone", null)
      }
    ] if _conf.route_enable && _conf.vpc_network_enable
  ])
}

resource "google_compute_route" "main" {
  for_each = { for v in local._route_conf_list : v.name => v }

  name                   = each.value.name
  dest_range             = each.value.dest_range
  network                = google_compute_network.main[each.value.network].self_link
  priority               = tonumber(each.value.priority)
  description            = each.value.description
  tags                   = each.value.tags
  next_hop_gateway       = each.value.next_hop_gateway
  next_hop_instance      = each.value.next_hop_instance
  next_hop_ip            = each.value.next_hop_ip
  next_hop_ilb           = each.value.next_hop_ilb != null ? data.google_compute_forwarding_rule.main[each.value.next_hop_ilb].id : null 
  next_hop_vpn_tunnel    = each.value.next_hop_vpn_tunnel
  next_hop_instance_zone = each.value.next_hop_instance_zone
}
