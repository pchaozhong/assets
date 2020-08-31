module "network" {
  source = "../modules/network"

  network_conf = [
    {
      vpc_conf = {
        vpc_enable    = false
        global_enable = true

        name       = "test"
        cidr_block = "192.168.0.0/16"
        opt_var    = {}
      }
      subnet_conf = [
        {
          subnet_enable = false

          name       = "test"
          cidr_block = "192.168.0.0/24"
          opt_var    = {}
        }
      ]

      route_table_conf = [
        {
          route_table_enable = true
          cidr_block = "0.0.0.0/0"
          opt_var = {
            gateway_id = "test"
          }
        }
      ]
    }
  ]
}
