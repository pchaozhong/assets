resource "google_container_cluster" "main" {
  count = var.gke_cluster_enabled ? 1 : 0

  name                      = var.gke_config["name"]
  network                   = var.gke_config["network"]
  location                  = var.gke_config["location"]
  subnetwork                = var.gke_config["subnetwork"]
  initial_node_count        = var.gke_config["initial_node_count"]
  remove_default_node_pool  = var.gke_config["remove_default_node_pool"]
  default_max_pods_per_node = var.gke_config["default_max_pods_per_node"]

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.gke_config["cluster_ip"]
    services_ipv4_cidr_block = var.gke_config["service_ip"]
  }

  node_config {
    oauth_scopes = var.gke_config["oauth_scopes"]
  }
}

resource "google_container_node_pool" "main" {
  for_each = { for conf in var.node_pool_configs : conf["name"] => conf if var.node_pool_enabled }

  name       = each.value["name"]
  cluster    = google_container_cluster.main[0].name
  location   = each.value["location"]
  node_count = each.value["node_count"]

  node_config {
    preemptible  = each.value["preemptible"]
    machine_type = each.value["machine_type"]

    oauth_scopes = each.value["oauth_scopes"]
  }
}
