locals {
  _cluster_conf = flatten([
    for _conf in var.gke_conf : [
      for _cluster in _conf.cluster : {
        name                      = _conf.cluster_name
        network                   = _cluster.network
        location                  = _cluster.location
        subnetwork                = _cluster.subnetwork
        node_config               = _cluster.node_config
        initial_node_count        = _cluster.initial_node_count
        ip_allocation_policy      = _cluster.ip_allocation_policy
        remove_default_node_pool  = _cluster.remove_default_node_pool
        default_max_pods_per_node = _cluster.default_max_pods_per_node
      }
    ] if _conf.cluster_enable
  ])
}

resource "google_container_cluster" "main" {
  for_each = { for v in local._cluster_conf : v.name => v }

  name                      = each.value.name
  network                   = data.google_compute_network.main[each.value.network]
  location                  = each.value.location
  subnetwork                = data.google_compute_subnetwork.main[each.value.subnetwork]
  initial_node_count        = each.value.initial_node_count
  remove_default_node_pool  = each.value.remove_default_node_pool
  default_max_pods_per_node = each.value.default_max_pods_per_node

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = each.value.ip_allocation_policy.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = each.value.ip_allocation_policy.services_ipv4_cidr_block
  }

  node_config {
    oauth_scopes = each.value.node_config.oauth_scopes
  }
}
