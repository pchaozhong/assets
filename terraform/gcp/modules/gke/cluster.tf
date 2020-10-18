resource "google_container_cluster" "main" {
  provider                 = "google-beta"
  name                     = var.cluster.name
  location                 = var.cluster.location
  cluster_ipv4_cidr        = var.cluster.networking_mode == "ROUTES" ? var.cluster.cluster_ipv4_cidr : null
  networking_mode          = var.cluster.networking_mode
  network                  = var.cluster.network
  remove_default_node_pool = true
  initial_node_count       = 1

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
