locals {
  _vpc_conf = flatten([
    for _conf in var.network_conf : {
      cidr_block = _conf.vpc_conf.cidr_block
      name       = _conf.vpc_conf.name
      opt_var    = _conf.vpc_conf.opt_var
    } if _conf.vpc_conf.vpc_enable
  ])

  _ig_conf = flatten([
    for _conf in var.network_conf : {
      vpc_id = _conf.vpc_conf.name
      name   = _conf.vpc_conf.name
    } if _conf.vpc_conf.vpc_enable && _conf.vpc_conf.global_enable
  ])
}

resource "aws_vpc" "main" {
  for_each = { for v in local._vpc_conf : v.name => v }

  cidr_block = each.value.cidr_block
  tags = {
    Name = each.value.name
  }

  instance_tenancy                 = lookup(each.value.opt_var, "instance_tenancy", null)
  enable_dns_support               = lookup(each.value.opt_var, "enable_dns_support", false)
  enable_dns_hostnames             = lookup(each.value.opt_var, "enable_dns_hostnames", false)
  enable_classiclink               = lookup(each.value.opt_var, "enable_classiclink", null)
  enable_classiclink_dns_support   = lookup(each.value.opt_var, "enable_classiclink_dns_support", null)
  assign_generated_ipv6_cidr_block = lookup(each.value.opt_var, "assign_generated_ipv6_cidr_block", null)
}

resource "aws_internet_gateway" "main" {
  for_each = { for v in local._ig_conf : v.name => v }

  vpc_id = aws_vpc.main[each.value.vpc_id].id
  tags = {
    Name = each.value.name
  }
}
