variable "network_conf" {
  type = list(object({
    vpc_network_enable      = bool
    subnetwork_enable       = bool
    firewall_ingress_enable = bool
    firewall_egress_enable  = bool
    route_enable            = bool

    vpc_network_conf = object({
      name                    = string
      opt_conf                = map(string)
    })

    subnetwork = list(object({
      name     = string
      cidr     = string
      region   = string
      opt_conf = map(string)
    }))

    firewall_ingress_conf = list(object({
      name     = string
      priority = number
      source_ranges = list(string)
      target_tags   = list(string)
      allow_rules = list(object({
        protocol = string
        ports    = list(string)
      }))
      deny_rules = list(object({
        protocol = string
        ports    = list(string)
      }))
      opt_conf = map(string)
    }))

    firewall_egress_conf = list(object({
      name     = string
      priority = number
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
      opt_conf = map(string)
    }))

    route_conf = list(object({
      name             = string
      dest_range       = string
      tags             = list(string)
      opt_conf = map(string)
    }))
  }))
}

