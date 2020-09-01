module "network" {
  source = "../modules/network"

  network_conf = [
    {
      vpc_conf = {
        global_enable = true

        name       = "test"
        cidr_block = "192.168.0.0/16"
        opt_var    = {}
      }
      subnet_conf = [
        {
          name       = "test"
          cidr_block = "192.168.0.0/24"
          opt_var    = {}
        }
      ]

      route_table_conf = [
        {
          cidr_block         = "0.0.0.0/0"
          opt_var = {
            gateway_id = "test"
          }
        }
      ]

      acl_ingress_conf = [
        {
          id     = 1

          protocol   = "tcp"
          rule_no    = 1000
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 22
          to_port    = 22
        }
      ]

      acl_egress_conf = []
    }
  ]
}

output "network" {
  value = module.network
}
