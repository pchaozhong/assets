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
    ]
  ])

  _vpn_tunnel_conf_list = flatten([
    for conf in local._vpn_tunnel_conf_tmp : [
      for peer in var.peer_vpn :  merge(conf, peer) if conf.name == peer.tunnel_name
    ]
  ])
}

variable "ha_vpn_conf" {
  type = list(object({
    gw_name = string
    region  = string
    network = string
    tunnel = list(object({
      tunnel_name           = string
      crypto_key            = string
      router                = string
      vpn_gateway_interface = number
    }))
  }))
}

variable "peer_vpn" {
  type = list(object({
    peer_gcp_gw = string
    tunnel_name = string
  }))
}

resource "google_compute_ha_vpn_gateway" "main" {
  for_each = { for v in var.ha_vpn_conf : v.gw_name => v }
  provider = google-beta

  name    = each.value.gw_name
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
