locals {
  _router_interface_list = flatten([
    for _router_conf in var.router_conf : [
      for _if_conf in _router_conf.interface : {
        name       = _if_conf.interface_name
        ip_range   = _if_conf.ip_range
        vpn_tunnel = _if_conf.vpn_tunnel
        region     = _router_conf.region
        router     = _router_conf.router_name
      }
    ] if var.vpn_enable
  ])

  _router_peer_list = flatten([
    for _router_conf in var.router_conf : [
      for _peer_conf in _router_conf.peer : {
        name                      = _peer_conf.peer_name
        router                    = _router_conf.router_name
        region                    = _router_conf.region
        peer_asn                  = _peer_conf.peer_asn
        interface                 = _peer_conf.interface
        peer_ip_address           = _peer_conf.peer_ip_address
        advertised_route_priority = _peer_conf.advertised_route_priority
      }
    ] if var.vpn_enable
  ])

  _router_conf = flatten([
    for _conf in var.router_conf : {
      name    = _conf.router_name
      network = data.google_compute_network.router_main[_conf.nw_name].self_link
      asn     = _conf.asn
    } if var.vpn_enable
  ])
}

resource "google_compute_router" "main" {
  for_each = { for v in local._router_conf : v.name => v }
  provider = google-beta

  name    = each.value.name
  network = each.value.network
  bgp {
    asn = each.value.asn
  }
}

resource "google_compute_router_interface" "main" {
  for_each = { for v in local._router_interface_list : v.name => v }
  provider = google-beta

  name       = each.value.name
  router     = google_compute_router.main[each.value.router].name
  region     = each.value.region
  ip_range   = each.value.ip_range
  vpn_tunnel = google_compute_vpn_tunnel.main[each.value.vpn_tunnel].self_link
}

resource "google_compute_router_peer" "main" {
  for_each = { for v in local._router_peer_list : v.name => v }
  provider = google-beta

  name                      = each.value.name
  router                    = google_compute_router.main[each.value.router].name
  region                    = each.value.region
  peer_asn                  = each.value.peer_asn
  interface                 = google_compute_router_interface.main[each.value.interface].name
  peer_ip_address           = each.value.peer_ip_address
  advertised_route_priority = each.value.advertised_route_priority
}
