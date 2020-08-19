locals {
  region = "asia-northeast1"
  zone = "asia-northeast1-b"
  network = "test"
  subnetwork = {
    name = "test"
    cidr = "192.168.0.0/29"
  }
}

module "network" {
  source = "./modules/network"

  network_conf = [
    {
      vpc_network_enable      = true
      subnetwork_enable       = true
      firewall_ingress_enable = true
      firewall_egress_enable  = true
      route_enable            = true

      vpc_network_conf = {
        name             = local.network
        auto_create_subnetworks = false
      }
      subnetwork = [
        {
          name   = local.subnetwork.name
          cidr   = local.subnetwork.cidr
          region = local.region
        }
      ]
      firewall_ingress_conf = []
      firewall_egress_conf = []
      route_conf = []
    }
  ]
}
