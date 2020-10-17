locals {
  gke_sample_enable = false

  _gke_sample_config = local.gke_sample_enable ? [{ name = "sample" }] : []
}

module "gke" {
  for_each = { for v in local._gke_sample_config : v.name => v }
  source   = "../modules/compute/gke"

  cluster = {
    name                      = "sample"
    location                  = "asia-northeast1"
    cluster_ipv4_cidr         = "10.0.0.0/9"
    default_max_pods_per_node = 110
    initial_node_count        = 1
    networking_mode           = "VPC_NATIVE"
    network                   = "default"
    service_account           = null
    cluster_ipv4_cidr_block   = null
    services_ipv4_cidr_block  = null

    cluster_autoscaling = {
      enabled = true
      resource_limits = [
        {
          resource_type = "cpu"
          minimum       = 1
          maximum       = 3
        },
        {
          resource_type = "memory"
          minimum       = 4
          maximum       = 10
        },
      ]
      min_cpu_platform = "Intel Haswell"
    }

    node_config = {
      disk_size_gb = 20
      disk_type    = "pd-standard"
      image_type   = "COS_CONTAINERD"
      machine_type = "n1-standard-1"
      oauth_scopes = []
    }
  }
}
