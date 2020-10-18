locals {
  gke_sample_enable = false

  _gke_sample_config = local.gke_sample_enable ? [{ name = "sample" }] : []
}

module "gke" {
  for_each = { for v in local._gke_sample_config : v.name => v }
  source   = "../modules/gke"

  cluster = {
    name                      = "sample"
    location                  = "asia-northeast1"
    cluster_ipv4_cidr         = "10.0.0.0/9"
    default_max_pods_per_node = 110
    networking_mode           = "VPC_NATIVE"
    network                   = "default"
    service_account           = null
    cluster_ipv4_cidr_block   = null
    services_ipv4_cidr_block  = null

    cluster_autoscaling = {
      enabled = false
      resource_limits = [
      ]
      min_cpu_platform = "Intel Haswell"
    }
  }

  node_pool = {
    name               = "sample"
    location           = "asia-northeast1"
    initial_node_count = 1
    node_locations = [
      "asia-northeast1-b"
    ]
    version     = null
    autoscaling = []
    upgrade     = []
  }

  node_count = 2
}
