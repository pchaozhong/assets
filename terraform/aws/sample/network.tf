module "network" {
  source = "../modules/network"

  network_conf = [
    {
      vpc_conf = {
        vpc_enable = false

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
    }
  ]
}

output "network" {
  value = module.network
}
