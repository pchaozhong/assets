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
        opt_conf = {}
      }
      subnetwork = [
        {
          name        = local.subnetwork.name
          cidr        = local.subnetwork.cidr
          description = "test"
          region      = local.region
          opt_conf = {
            log_config           = false
            aggregation_interval = "INTERVAL_10_MIN"
            flow_sampling        = 0.5
            metadata             = "INCLUDE_ALL_METADATA"

            secondary_ip_range = false
            ip_cidr_range      = "192.168.10.0/24"
            range_name         = "test-module-sec-range"
          }
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
          opt_conf = {
            log_config = false
            metadata = "EXCLUDE_ALL_METADATA"
          }
        }
      ]
      firewall_egress_conf = []
      route_conf = [
        {
          name             = "test-dg"
          dest_range       = "0.0.0.0/0"
          tags             = []
          opt_conf = {
            next_hop_gateway = "default-internet-gateway"
            priority         = "1000"
          }
        }
      ]
    }
  ]
}
