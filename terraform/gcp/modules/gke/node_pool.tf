locals {
  _node_pool_conf = flatten([
    for _conf in var.gke_conf : [
      for _node_pool in _conf.node_pool : {
        name        = _node_pool.name
        cluster     = _conf.cluster_name
        location    = _node_pool.location
        node_count  = _node_pool.node_count
        node_config = _node_pool.node_config
      }
    ] if _conf.node_pool_enable && _conf.cluster_enable
  ])
}

resource "google_container_node_pool" "main" {
  for_each = { for v in local._node_pool_conf : v.name => v }

  name       = each.value.name
  cluster    = google_container_cluster.main[each.value.cluster].name
  location   = each.value.location
  node_count = each.value.node_count

  node_config {
    preemptible  = each.value.node_config.preemptible
    machine_type = each.value.node_config.machine_type

    oauth_scopes = each.value.node_config.oauth_scopes
  }
}
