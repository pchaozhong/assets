locals {
  zone = "asia-northeast1-b"
  region = "asia-northeast1"
}

variable "image" {
  type = string
}

module "gce" {
  source = "../../../terraform/gcp/modules/gce"

  gce_conf = [
    {
      gce_enable = false

      name         = "docker"
      machine_type = "f1-micro"
      zone         = local.zone
      tags         = ["test"]
      network      = module.nw.subnetwork_self_link.custom-img
      boot_disk = {
        size        = 10
        image       = var.image
        type        = "pd-ssd"
        auto_delete = true
      }
      access_config = [
        {
          access_config_enable = true
          nat_ip               = null
        }
      ]
      scheduling = [
        {
          scheduling_enable   = true
          preemptible         = true
          on_host_maintenance = "TERMINATE"
          automatic_restart   = false
        }
      ]
    }
  ]
}

module "nw" {
  source = "../../../terraform/gcp/modules/network"

  network_conf = [
    {
      vpc_network_enable      = true
      subnetwork_enable       = true
      firewall_ingress_enable = true
      firewall_egress_enable  = false
      route_enable            = true

      vpc_network_conf = {
        name             = "custom-img"
        auto_create_subnetworks = false
      }
      subnetwork = [
        {
          name   = "custom-img"
          cidr   = "192.168.0.0/24"
          region = local.region
        }
      ]
      firewall_ingress_conf = [
        {
          name           = "docker-custom-img"
          priority       = 1000
          enable_logging = false
          source_ranges  = ["0.0.0.0/0"]
          target_tags    = []
          allow_rules = [
            {
              protocol = "tcp"
              ports = ["22", "80"]
            }
          ]
          deny_rules = []
        }
      ]
      firewall_egress_conf = []
      route_conf = [
        {
          name             = "docker-route"
          dest_range       = "0.0.0.0/0"
          priority         = 1000
          tags             = []
          next_hop_gateway = "default-gateway"
        }
      ]
    }
  ]
}
