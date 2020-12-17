locals {
  inspec_test_infra_enable = true

  _insple_test = local.inspec_test_infra_enable ? [
    {
      network = "test"
      subnets = [
        {
          name   = "test-tokyo"
          cidr   = "192.168.0.0/29"
          region = "asia-northeast1"
        },
        {
          name   = "test-osaka"
          cidr   = "192.168.0.8/29"
          region = "asia-northeast2"
        }
      ]
    }
  ] : []
}

module "network" {
  for_each = { for v in local._insple_test : v.network => v }
  source   = "./terraform/gcp/modules/network/vpc_network"

  vpc_network = {
    name = each.value.network
  }

  subnetworks = [
    for v in each.value.subnetworks : {
      name   = v.name
      cidr   = v.cidr
      region = v.cidr
    }
  ]

  firewall = []
}
