module "dns" {
  source = "./modules/dns"

  dns_conf = [
    {
      zone_name = "restricted"
      mng_zone = [
        {
          dns_name = "googleapis.com."
          visibility = "private"
          private_visibility_config = [
            {
              network_url = module.network.network_self_link.dns-test
            }
          ]
          forwarding_config = []
        }
      ]

      record_set = [
        {
          id = "restricted-cname"
          name = "*.googleapis.com."
          type = "CNAME"
          ttl = 300
          rrdatas = ["restricted.googleapis.com."]
        },
        {
          id = "restricted-a-record"
          name = "restricted.googleapis.com."
          type = "A"
          ttl = 300
          rrdatas = ["199.36.153.4", "199.36.153.5", "199.36.153.6", "199.36.153.7"]
        },
      ]
    }
  ]
}

module "network" {
  source = "./modules/network"

  network_conf = [
    {
      vpc_network = "dns-test"
      auto_create_subnetworks = false
      subnetwork = [
        {
          name = "dns-test"
          cidr = "192.168.0.0/29"
          region = local.region
        }
      ]
      firewall_ingress_conf = []
      firewall_egress_conf = []
      route_conf = []
    }
  ]
}
