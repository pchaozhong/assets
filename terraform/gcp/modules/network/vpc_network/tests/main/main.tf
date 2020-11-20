locals {
  inspec_test_infra_enable = true

  _insple_test = local.inspec_test_infra_enable ? [
    {
      name   = "test"
      cidr   = "192.168.0.0/29"
      region = "asia-northeast1"
    }
  ] : []
}

module "network" {
  for_each = { for v in local._insple_test : v.name => v }
  source   = "../../"

  vpc_network = {
    name = each.value.name
  }

  subnetworks = [
    {
      name   = each.value.name
      cidr   = each.value.cidr
      region = each.value.region
    }
  ]

  firewall = []
}
