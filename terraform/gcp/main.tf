locals {
  zone   = "asia-northeast1-b"
  region = "asia-northeast1"
}

module "network" {
  source = "./modules/network"

  vpc_network_conf = [
    {
      name                    = "test"
      auto_create_subnetworks = false
    }
  ]

  subnetwork_conf = [
    {
      name        = "test"
      vpc_network = "test"
      cidr        = "192.168.0.0/16"
      region      = local.region
    }
  ]

  firewall_ingress_conf = [
    {
      name           = "test"
      network        = "test"
      priority       = 1000
      enable_logging = false
      source_ranges = [
        "0.0.0.0/0"
      ]
      target_tags = [
        "test"
      ]
      allow_rules = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      deny_rules = []
    }
  ]

  firewall_egress_conf = []

  route_conf = [
    {
      name             = "test"
      network          = "test"
      dest_range       = "0.0.0.0/0"
      priority         = 1000
      tags             = ["test"]
      next_hop_gateway = "default-internet-gateway"
    }
  ]

}
