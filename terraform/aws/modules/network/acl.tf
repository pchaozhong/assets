locals {
  _acl_conf = flatten([
    for _conf in var.network_conf : {
      vpc     = _conf.vpc_conf.name
      ingress = local._acl_ingress_tmp
      egress  = local._acl_egress_tmp
    }
  ])

  _acl_ingress_tmp = flatten([
    for _conf in var.network_conf : [
      for _acl_conf in _conf.acl_ingress_conf : _acl_conf
    ]
  ])

  _acl_egress_tmp = flatten([
    for _conf in var.network_conf : [
      for _acl_conf in _conf.acl_egress_conf : _acl_conf
    ]
  ])

}

resource "aws_network_acl" "main" {
  for_each = { for v in local._acl_conf : v.vpc => v }

  vpc_id = aws_vpc.main[each.value.vpc].id
  # subnet_ids = []

  dynamic "ingress" {
    for_each = { for _ing in each.value.ingress : _ing.id => _ing }
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = { for _eg in each.value.egress : _eg.id => _eg }
    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }

  tags = {
    Name = each.value.vpc
  }


}
