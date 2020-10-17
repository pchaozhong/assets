resource "google_container_cluster" "main" {
  provider                  = "google-beta"
  name                      = var.cluster.name
  location                  = var.cluster.location
  cluster_ipv4_cidr         = var.cluster.networking_mode == "ROUTES" ? var.cluster.cluster_ipv4_cidr : null
  default_max_pods_per_node = var.cluster.networking_mode == "VPC_NATIVE" ? var.cluster.default_max_pods_per_node : null
  initial_node_count        = var.cluster.initial_node_count
  networking_mode           = var.cluster.networking_mode
  network                   = var.cluster.network

  cluster_autoscaling {
    enabled = var.cluster.cluster_autoscaling.enabled

    dynamic "resource_limits" {
      for_each = var.cluster.cluster_autoscaling.resource_limits
      iterator = resource

      content {
        resource_type = resource.value.resource_type
        minimum       = resource.value.minimum
        maximum       = resource.value.maximum
      }
    }

    auto_provisioning_defaults {
      min_cpu_platform = var.cluster.cluster_autoscaling.min_cpu_platform
      service_account  = var.cluster.service_account
    }
  }

  node_config {
    disk_size_gb    = var.cluster.node_config.disk_size_gb
    disk_type       = var.cluster.node_config.disk_type
    image_type      = var.cluster.node_config.image_type
    machine_type    = var.cluster.node_config.machine_type
    oauth_scopes    = var.cluster.node_config.oauth_scopes
    service_account = var.cluster.service_account
  }

  dynamic "ip_allocation_policy" {
    iterator = policy
    for_each = var.cluster.networking_mode == "VPC_NATIVE" ? [{
      cluster_ipv4_cidr_block  = var.cluster.cluster_ipv4_cidr_block
      services_ipv4_cidr_block = var.cluster.services_ipv4_cidr_block
    }] : []
    content {
      cluster_ipv4_cidr_block  = policy.value.cluster_ipv4_cidr_block
      services_ipv4_cidr_block = policy.value.services_ipv4_cidr_block
    }
  }
}
