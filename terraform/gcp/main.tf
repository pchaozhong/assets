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

module "gce" {
  source = "./modules/gce"

  gce_conf = [
    {
      name             = "test"
      machine_type     = "f1-micro"
      zone             = local.zone
      tags             = ["test"]
      network          = module.network.subnetwork_self_link.test
      disk_size        = 10
      disk_image       = "ubuntu-2004-lts"
      disk_type        = "pd-ssd"
      disk_auto_delete = true
      access_config = [
        { enable = true }
      ]
      scheduling = [
        {
          preemptible         = true
          on_host_maintenance = "TERMINATE"
          automatic_restart   = false
        }
      ]
    }
  ]
}
