variable "cluster" {
  type = object({
    name                      = string
    location                  = string
    cluster_ipv4_cidr         = string
    default_max_pods_per_node = number
    initial_node_count        = number
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

    node_config = object({
      disk_size_gb = number
      disk_type    = string
      image_type   = string
      machine_type = string
      oauth_scopes = list(string)
    })
  })
}
