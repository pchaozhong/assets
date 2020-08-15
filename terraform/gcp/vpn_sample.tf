locals {
  vpn = {
    hub   = "hub"
    spoke = "spoke"
    secret = {
      ciphertext = "CiQAtQAd5XMKz5C6tFgtlEL0qSdb6zzzv9psSbNQSLNX//Jja9kSSQCD2/5sSMp0Vcs/op0CJk4lfv1WFN0LSSaxixCeeDQZGYvuxDQ1vCUorWjhqPPG8F3UAhNbEnshRITvUISo7LLEP4o7tQKUL4I="
      key_ring   = "demo_kitano"
      crypto_key = "symmetry_demo"
      location   = "global"
    }
  }
}

module "vpn_network" {
  source = "./modules/network"

  network_conf = [
    {
      vpc_network = local.vpn.hub
      auto_create_subnetworks = false
      subnetwork = [
        {
          name = local.vpn.hub
          cidr = "192.168.10.0/24"
          region = local.region
        }
      ]
      firewall_ingress_conf = []
      firewall_egress_conf = []
      route_conf = []
    },
    {
      vpc_network = local.vpn.spoke
      auto_create_subnetworks = false
      subnetwork = [
        {
          name = local.vpn.spoke
          cidr = "192.168.20.0/24"
          region = local.region
        }
      ]
      firewall_ingress_conf = []
      firewall_egress_conf = []
      route_conf = []
    }
  ]
}

module "ha_vpn_hub" {
  source = "./modules/ha_vpn"

  router_conf = [
    {
      router_name = local.vpn.hub
      network     = module.vpn_network.network_self_link[local.vpn.hub]
      asn         = 64515
      region      = local.region
      interface = [
        {
          interface_name = join("-", [local.vpn.hub, 1])
          ip_range       = "169.254.0.2/30"
          vpn_tunnel     = "hub-1"
        },
        {
          interface_name = join("-", [local.vpn.hub, 2])
          ip_range       = "169.254.1.2/30"
          vpn_tunnel     = "hub-2"
        }
      ]
      peer = [
        {
          peer_name                 = join("-", [local.vpn.hub, 1])
          peer_asn                  = 64516
          interface                 = join("-", [local.vpn.hub, 1])
          peer_ip_address           = "169.254.0.1"
          advertised_route_priority = 2000
        },
        {
          peer_name                 = join("-", [local.vpn.hub, 2])
          peer_asn                  = 64516
          interface                 = join("-", [local.vpn.hub, 2])
          peer_ip_address           = "169.254.1.1"
          advertised_route_priority = 2001
        }
      ]
    }
  ]

  ha_vpn_conf = [
    {
      gw_name = local.vpn.hub
      region  = local.region
      network = module.vpn_network.network_self_link[local.vpn.hub]
      tunnel = [
        {
          tunnel_name           = join("-", [local.vpn.hub, 1])
          crypto_key            = local.vpn.secret.crypto_key
          vpn_gateway_interface = 0
          router                = local.vpn.hub
        },
        {
          tunnel_name           = join("-", [local.vpn.hub, 2])
          crypto_key            = local.vpn.secret.crypto_key
          vpn_gateway_interface = 1
          router                = local.vpn.hub
        }
      ]
    }
  ]
  peer_vpn = [
    {
      peer_gcp_gw = module.ha_vpn_spoke.ha_vpn_gateway_self_link[local.vpn.spoke]
      tunnel_name = join("-", [local.vpn.hub, 1])
    },
    {
      peer_gcp_gw = module.ha_vpn_spoke.ha_vpn_gateway_self_link[local.vpn.spoke]
      tunnel_name = join("-", [local.vpn.hub, 2])
    }
  ]

  secret = [
    {
      crypto_key = local.vpn.secret.crypto_key
      ciphertext = local.vpn.secret.ciphertext
      key_ring   = local.vpn.secret.key_ring
      location   = local.vpn.secret.location
    }
  ]
}

module "ha_vpn_spoke" {
  source = "./modules/ha_vpn"

  router_conf = [
    {
      router_name = local.vpn.spoke
      network     = module.vpn_network.network_self_link[local.vpn.spoke]
      asn         = 64516
      region      = local.region
      interface = [
        {
          interface_name = join("-",[local.vpn.spoke,1])
          ip_range       = "169.254.0.1/30"
          vpn_tunnel     = join("-",[local.vpn.spoke,1])
        },
        {
          interface_name = join("-",[local.vpn.spoke,2])
          ip_range       = "169.254.1.1/30"
          vpn_tunnel     = join("-",[local.vpn.spoke,2])
        }
      ]
      peer = [
        {
          peer_name                 = join("-",[local.vpn.spoke,1])
          peer_asn                  = 64515
          interface                 = join("-",[local.vpn.spoke,1])
          peer_ip_address           = "169.254.0.2"
          advertised_route_priority = 2000
        },
        {
          peer_name                 = join("-",[local.vpn.spoke,2])
          peer_asn                  = 64515
          interface                 = join("-",[local.vpn.spoke,2])
          peer_ip_address           = "169.254.1.2"
          advertised_route_priority = 2001
        }
      ]
    }
  ]

  ha_vpn_conf = [
    {
      gw_name = local.vpn.spoke
      region  = local.region
      network = module.vpn_network.network_self_link[local.vpn.spoke]
      tunnel = [
        {
          tunnel_name           = join("-",[local.vpn.spoke,1])
          crypto_key            = local.vpn.secret.crypto_key
          vpn_gateway_interface = 0
          router                = local.vpn.spoke
        },
        {
          tunnel_name           = join("-",[local.vpn.spoke,2])
          crypto_key            = local.vpn.secret.crypto_key
          vpn_gateway_interface = 1
          router                = local.vpn.spoke
        },
      ]
    }
  ]
  peer_vpn = [
    {
      peer_gcp_gw = module.ha_vpn_hub.ha_vpn_gateway_self_link[local.vpn.hub]
      tunnel_name = join("-",[local.vpn.spoke,1])
    },
    {
      peer_gcp_gw = module.ha_vpn_hub.ha_vpn_gateway_self_link[local.vpn.hub]
      tunnel_name = join("-",[local.vpn.spoke,2])
    }
  ]
  secret = [
    {
      crypto_key = local.vpn.secret.crypto_key
      ciphertext = local.vpn.secret.ciphertext
      key_ring   = local.vpn.secret.key_ring
      location   = local.vpn.secret.location
    }
  ]
}
