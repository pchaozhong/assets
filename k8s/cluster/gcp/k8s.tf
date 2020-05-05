locals {
  location = "asia-northeast1-b"
  machine_type = "n1-standard-1"
  node_count = 1
}

resource "google_container_cluster" "primary" {
  name = "demo"
  location = local.location

  remove_default_node_pool = true
  initial_node_count = 1
}

resource "google_container_node_pool" "primary_preemptible_node" {
  name = "demo"
  location = local.location
  cluster = google_container_cluster.primary.name
  node_count = local.node_count

  node_config {
    preemptible = true
    machine_type = local.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}
