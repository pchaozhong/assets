module "dns" {
  depends_on = [ module.network_dns ]
  source = "../modules/dns"

  dns_conf = [
    {
      dns_zone_enable   = false
      record_set_enable = false

      zone_name = "restricted"
      mng_zone = [
        {
          dns_name   = "googleapis.com."
          visibility = "private"
          private_visibility_config = [
            {
              network = "dns-test"
            }
          ]
          forwarding_config = []
        }
      ]

      record_set = [
        {
          id      = "restricted-cname"
          name    = "*.googleapis.com."
          type    = "CNAME"
          ttl     = 300
          rrdatas = ["restricted.googleapis.com."]
        },
        {
          id      = "restricted-a-record"
          name    = "restricted.googleapis.com."
          type    = "A"
          ttl     = 300
          rrdatas = ["199.36.153.4", "199.36.153.5", "199.36.153.6", "199.36.153.7"]
        },
      ]
    }
  ]
}

module "network_dns" {
  source = "../modules/network"

  network_conf = [
    {
      vpc_network_enable      = false
      subnetwork_enable       = false
      firewall_ingress_enable = false
      firewall_egress_enable  = false
      route_enable            = false

      vpc_network_conf = {
        name                    = "dns-test"
        auto_create_subnetworks = false
        opt_conf = {}
      }
      subnetwork = [
        {
          name   = "dns-test"
          cidr   = "10.2.0.0/16"
          region = local.region
          opt_conf = {
          }
        }
      ]
      firewall_ingress_conf = []
      firewall_egress_conf  = []
      route_conf            = []
    }
  ]
}
