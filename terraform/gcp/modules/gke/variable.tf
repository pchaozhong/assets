variable "gke_conf" {
  type = list(object({
    cluster_enable   = bool
    node_pool_enable = bool

    cluster_name = string

    cluster = list(object({
      network                   = string
      location                  = string
      subnetwork                = string
      initial_node_count        = number
      remove_default_node_pool  = bool
      default_max_pods_per_node = number

      ip_allocation_policy = object({
        cluster_ipv4_cidr_block  = string
        services_ipv4_cidr_block = string
      })

      node_config = object({
        oauth_scopes = list(string)
      })
    }))

    node_pool = list(object({
      name       = string
      location   = string
      node_count = number
      node_config = object({
        machine_type = string
        oauth_scopes = list(string)
      })
    }))

  }))
}

variable "preemptible_enable" {
  type = bool
  default = false
}
