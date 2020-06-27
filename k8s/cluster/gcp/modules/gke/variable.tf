variable "gke_cluster_enabled" {
  type    = bool
  default = true
}

variable "node_pool_enabled" {
  type    = bool
  default = true
}

variable "gke_config" {
  type = object(
    {
      name                      = string
      location                  = string
      remove_default_node_pool  = bool
      network                   = string
      subnetwork                = string
      cluster_ip                = string
      service_ip                = string
      oauth_scopes              = list(string)
      initial_node_count        = number
      default_max_pods_per_node = number
    }
  )
}

variable "node_pool_configs" {
  type = list(object({
    name         = string
    location     = string
    node_count   = number
    preemptible  = bool
    machine_type = string
    oauth_scopes = list(string)
  }))
}
