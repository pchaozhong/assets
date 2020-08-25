locals {
  gke = {
    node_count   = 1
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    cluster = {
      cluster_ip  = "172.16.0.0/16"
      services_ip = "10.10.0.0/16"
    }
    node_pool = {
      machine_type = "n1-standard-1"
      name         = "demo"
    }
  }
}

module "gke" {
  depends_on = [ module.network ]
  source = "../modules/gke"

  preemptible_enable = true
  gke_conf = yamldecode(file("./files/gke.yaml"))
}
