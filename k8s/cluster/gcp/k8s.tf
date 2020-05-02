locals {
  location = "asia-northeast1-b"
  machine_type = "n1-standard-1"
}

resource "google_container_cluster" "primary" {
  name = "demo"
  location = local.location

  remove_default_node_pool = true
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_node" {
  name = "demo-node"
  location = local.location
  cluster = google_container_cluster.primary.name

  initial_node_count = 1
  node_count = 1

  node_config {
    preemptible = true
    machine_type = local.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}
