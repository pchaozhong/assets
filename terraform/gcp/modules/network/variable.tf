variable "network_conf" {
  type = list(object({
    vpc_network_enable      = bool
    subnetwork_enable       = bool
    firewall_ingress_enable = bool
    firewall_egress_enable  = bool
    route_enable            = bool

    vpc_network_conf = object({
      name                    = string
      auto_create_subnetworks = bool
    })

    subnetwork = list(object({
      name   = string
      cidr   = string
      region = string
    }))

    firewall_ingress_conf = list(object({
      name           = string
      priority       = number
      enable_logging = bool
      source_ranges  = list(string)
      target_tags    = list(string)
      allow_rules = list(object({
        protocol = string
        ports    = list(string)
      }))
      deny_rules = list(object({
        protocol = string
        ports    = list(string)
      }))
    }))

    firewall_egress_conf = list(object({
      name               = string
      priority           = number
      enable_logging     = bool
      destination_ranges = list(string)
      target_tags        = list(string)
      allow_rules = list(object({
        protocol = string
        ports    = list(string)
      }))
      deny_rules = list(object({
        protocol = string
        ports    = list(string)
      }))
    }))

    route_conf = list(object({
      name             = string
      dest_range       = string
      priority         = number
      tags             = list(string)
      next_hop_gateway = string
    }))
  }))
}

