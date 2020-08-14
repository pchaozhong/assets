variable "vpc_network_conf" {
  type = list(object({
    name                    = string
    auto_create_subnetworks = bool
  }))
}

variable "subnetwork_conf" {
  type = list(object({
    name        = string
    vpc_network = string
    cidr        = string
    region      = string
  }))
}

variable "firewall_ingress_conf" {
  type = list(object({
    name        = string
    network = string
    priority = number
    enable_logging = bool
    source_ranges = list(string)
    target_tags = list(string)
    allow_rules = list(object({
      protocol = string
      ports = list(string)
    }))
    deny_rules = list(object({
      protocol = string
      ports = list(string)
    }))
  }))
}

variable "firewall_egress_conf" {
  type = list(object({
    name        = string
    network = string
    priority = number
    enable_logging = bool
    destination_ranges = list(string)
    target_tags = list(string)
    allow_rules = list(object({
      protocol = string
      ports = list(string)
    }))
    deny_rules = list(object({
      protocol = string
      ports = list(string)
    }))
  }))
}

variable "route_conf" {
  type = list(object({
    name             = string
    dest_range       = string
    network          = string
    priority         = number
    tags             = list(string)
    next_hop_gateway = string
  }))
}
