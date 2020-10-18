variable "cluster" {
  type = object({
    name                      = string
    location                  = string
    cluster_ipv4_cidr         = string
    default_max_pods_per_node = number
    networking_mode           = string
    network                   = string
    service_account           = string
    cluster_ipv4_cidr_block   = string
    services_ipv4_cidr_block  = string

    cluster_autoscaling = object({
      enabled = bool
      resource_limits = list(object({
        resource_type = string
        minimum       = number
        maximum       = number
      }))
      min_cpu_platform = string
    })
  })
}

variable "node_pool" {
  type = object({
    name               = string
    location           = string
    initial_node_count = number
    node_locations     = list(string)
    version            = string
    autoscaling = list(object({
      min_node_count = number
      max_node_count = number
    }))
    upgrade = list(object({
      max_surge       = number
      max_unavailable = number
    }))
  })
}

variable "node_count" {
  type    = number
  default = null
}

variable "node_pool_max_pods" {
  type    = number
  default = null
}

variable "name_prefix" {
  type    = string
  default = null
}
