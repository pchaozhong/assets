variable "network_conf" {
  type = list(object({

    vpc_conf = object({
      name          = string
      cidr_block    = string
      vpc_enable    = bool
      global_enable = bool
      opt_var       = map(string)
    })

    subnet_conf = list(object({
      name          = string
      subnet_enable = bool
      cidr_block    = string
      opt_var       = map(string)
    }))

    route_table_conf = list(object({
      cidr_block         = string
      opt_var            = map(string)
      route_table_enable = bool
    }))


    acl_ingress_conf = list(object({
      enable     = bool
      id         = number
      protocol   = string
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
    }))

    acl_egress_conf = list(object({
      enable     = bool
      id         = number
      protocol   = string
      rule_no    = number
      action     = string
      cidr_block = string
      from_port  = number
      to_port    = number
    }))

  }))
}
