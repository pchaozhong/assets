variable "vpn_enable" {
  type    = bool
  default = false
}

variable "ha_vpn_conf" {
  type = list(object({
    gw_name = string
    region  = string
    # network = string
    nw_name = string
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

variable "router_conf" {
  type = list(object({
    router_name = string
    # network     = string
    nw_name = string
    asn     = number
    region  = string
    interface = list(object({
      interface_name = string
      ip_range       = string
      vpn_tunnel     = string
    }))
    peer = list(object({
      peer_name                 = string
      peer_asn                  = number
      interface                 = string
      peer_ip_address           = string
      advertised_route_priority = number
    }))
  }))
}
