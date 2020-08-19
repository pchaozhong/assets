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
        name                    = local.network
        auto_create_subnetworks = false
      }
      subnetwork = [
        {
          name   = local.subnetwork.name
          cidr   = local.subnetwork.cidr
          region = local.region
        }
      ]
      firewall_ingress_conf = [
        {
          name          = "test-nw"
          priority      = 1000
          source_ranges = ["0.0.0.0/0"]
          target_tags   = []
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
          name             = "test-dg"
          dest_range       = "0.0.0.0/0"
          priority         = 1000
          tags             = []
          next_hop_gateway = "default-internet-gateway"
        }
      ]
    }
  ]
}
