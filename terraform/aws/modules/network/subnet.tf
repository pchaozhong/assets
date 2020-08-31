locals {
  _subnet_conf = flatten([
    for _conf in var.network_conf : [
      for _sub in _conf.subnet_conf : {
        name       = _sub.name
        vpc        = _conf.vpc_conf.name
        cidr_block = _sub.cidr_block
        opt_var    = _sub.opt_var
      } if _sub.subnet_enable && _conf.vpc_conf.vpc_enable
    ]
  ])
}

resource "aws_subnet" "main" {
  for_each = { for v in local._subnet_conf : v.name => v }

  tags = {
    Name = each.value.name
  }
  vpc_id     = aws_vpc.main[each.value.vpc].id
  cidr_block = each.value.cidr_block

  availability_zone       = lookup(each.value.opt_var, "availability_zone", null)
  availability_zone_id    = lookup(each.value.opt_var, "availability_zone_id", null)
  map_public_ip_on_launch = lookup(each.value.opt_var, "map_public_ip_on_launch", false)
  outpost_arn             = lookup(each.value.opt_var, "outpost_arn", null)
}
