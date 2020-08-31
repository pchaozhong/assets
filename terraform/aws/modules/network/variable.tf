variable "network_conf" {
  type = list(object({

    vpc_conf = object({
      name = string
      cidr_block = string
      vpc_enable = bool
      opt_var = map(string)
    })

    subnet_conf = list(object({
      name = string
      subnet_enable = bool
      cidr_block = string
      opt_var = map(string)
    }))
  }))
}
