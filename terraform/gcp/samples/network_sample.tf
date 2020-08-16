module "network" {
  source = "../modules/network"

  network_conf = [
    {
      vpc_network_enable      = false
      subnetwork_enable       = false
      firewall_ingress_enable = false
      firewall_egress_enable  = false
      route_enable            = false

      vpc_network_conf = {
        name             = "test"
        auto_create_subnetworks = false
      }
      subnetwork = [
        {
          name   = "test"
          cidr   = "192.168.0.0/24"
          region = local.region
        }
      ]
      firewall_ingress_conf = [
      ]
      firewall_egress_conf = []
      route_conf = [
      ]
    },
    {
      vpc_network_enable      = false
      subnetwork_enable       = false
      firewall_ingress_enable = false
      firewall_egress_enable  = false
      route_enable            = false

      vpc_network_conf = {
        name             = "test2"
        auto_create_subnetworks = false
      }
      subnetwork = [
        {
          name   = "test2"
          cidr   = "192.168.1.0/24"
          region = local.region
        },
        {
          name   = "test3"
          cidr   = "192.168.32.0/24"
          region = local.region
        },
      ]
      firewall_ingress_conf = [
        {
          name = "ssh-enable"
          priority = 1000
          enable_logging = false
          source_ranges = ["0.0.0.0/0"]
          target_tags = ["test"]
          allow_rules = [
            {
              protocol = "tcp"
              ports = ["22"]
            }
          ]
          deny_rules = []
        },
        {
          name = "http-enable"
          priority = 1000
          enable_logging = false
          source_ranges = ["0.0.0.0/0"]
          target_tags = ["test","web"]
          allow_rules = [
            {
              protocol = "tcp"
              ports = ["80"]
            }
          ]
          deny_rules = []
        }
      ]
      firewall_egress_conf = []
      route_conf = [
      ]
    },

  ]
}
