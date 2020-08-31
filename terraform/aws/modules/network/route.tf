locals {
  _rt_table_conf = flatten([
    for _conf in var.network_conf : {
      vpc = _conf.vpc_conf.name
      routes = local._rt_tb_conf_tmp
    } if _conf.vpc_conf.vpc_enable
  ])

  _rt_tb_conf_tmp = flatten([
    for _conf in var.network_conf : [
      for _rt_conf in _conf.route_table_conf : {
        cidr_block                = _rt_conf.cidr_block
        gateway_id                = lookup(_rt_conf.opt_var, "gateway_id", null)
        instance_id               = lookup(_rt_conf.opt_var, "instance_id", null)
        nat_gateway_id            = lookup(_rt_conf.opt_var, "nat_gateway_id", null)
        network_interface_id      = lookup(_rt_conf.opt_var, "network_interface_id", null)
        vpc_peering_connection_id = lookup(_rt_conf.opt_var, "vpc_peering_connection_id", null)
      } if _rt_conf.route_table_enable
    ]
  ])
}

resource "aws_route_table" "main" {
  for_each = { for v in local._rt_table_conf : v.vpc => v }

  vpc_id = aws_vpc.main[each.value.vpc].id

  dynamic "route" {
    for_each = { for v in each.value.routes : v.cidr_block => v }
    content {
      cidr_block                = route.value.cidr_block
      gateway_id                = aws_internet_gateway.main[route.value.gateway_id].id
      instance_id               = route.value.instance_id
      nat_gateway_id            = route.value.nat_gateway_id
      network_interface_id      = route.value.network_interface_id
      vpc_peering_connection_id = route.value.vpc_peering_connection_id
    }
  }
}
