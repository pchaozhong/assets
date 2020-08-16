module "network" {
  source = "../modules/network"

  network_conf = [
    {
      vpc_network             = "test"
      auto_create_subnetworks = false
      subnetwork = [
        {
          name   = "test"
          cidr   = "192.168.10.0/24"
          region = local.region
        }
      ]
      firewall_ingress_conf = [
        {
          name           = "test-ssh-ingress"
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
          name       = "test"
          dest_range = "0.0.0.0/0"
          priority   = 1000
          tags = [
            "test"
          ]
          next_hop_gateway = "default-internet-gateway"
        }
      ]
    }
  ]
}
