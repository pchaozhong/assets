locals {
  _vpn_tunnel_conf_tmp = flatten([
    for _gw_conf in var.ha_vpn_conf : [
      for _tunnel_conf in _gw_conf.tunnel : {
        vpn_gateway           = _gw_conf.gw_name
        region                = _gw_conf.region
        name                  = _tunnel_conf.tunnel_name
        router                = _tunnel_conf.router
        crypto_key            = _tunnel_conf.crypto_key
        vpn_gateway_interface = _tunnel_conf.vpn_gateway_interface
      }
    ] if var.vpn_enable
  ])

  _vpn_tunnel_conf_list = flatten([
    for conf in local._vpn_tunnel_conf_tmp : [
      for peer in var.peer_vpn : merge(conf, peer) if conf.name == peer.tunnel_name
    ] if var.vpn_enable
  ])

  _vpn_gw_conf = flatten([
    for _conf in var.ha_vpn_conf : {
      name    = _conf.gw_name
      network = data.google_compute_network.vpn_main[_conf.nw_name].self_link
      region  = _conf.region
    } if var.vpn_enable
  ])
}

resource "google_compute_ha_vpn_gateway" "main" {
  for_each = { for v in local._vpn_gw_conf : v.name => v }
  provider = google-beta

  name    = each.value.name
  region  = each.value.region
  network = each.value.network
}

resource "google_compute_vpn_tunnel" "main" {
  for_each = { for v in local._vpn_tunnel_conf_list : v.name => v }
  provider = google-beta

  name                  = each.value.name
  region                = each.value.region
  vpn_gateway           = google_compute_ha_vpn_gateway.main[each.value.vpn_gateway].self_link
  peer_gcp_gateway      = each.value.peer_gcp_gw
  shared_secret         = data.google_kms_secret.main[each.value.crypto_key].plaintext
  router                = google_compute_router.main[each.value.router].self_link
  vpn_gateway_interface = each.value.vpn_gateway_interface
}
