locals {
  gke = {
    node_count = 1
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    cluster = {
      cluster_ip = "172.16.0.0/16"
      services_ip = "10.10.0.0/16"
    }
    node_pool = {
      machine_type = "n1-standard-1"
      name = "demo"
    }
  }
}

module "gke" {
  source = "../modules/gke"

  gke_conf = [
    {
      cluster_name = "test"
      cluster = [
        {
          network = module.network.network_self_link.test
          location = local.region
          subnetwork = module.network.subnetwork_self_link.test
          initial_node_count = local.gke.node_count
          remove_default_node_pool = true
          default_max_pods_per_node = null
          ip_allocation_policy = {
            cluster_ipv4_cidr_block = local.gke.cluster.cluster_ip
            services_ipv4_cidr_block = local.gke.cluster.services_ip
          }
          node_config = {
            oauth_scopes = local.gke.oauth_scopes
          }
        }
      ]
      node_pool = [
        {
          name = local.gke.node_pool.name
          location = local.region
          node_count = local.gke.node_count
          node_config = {
            preemptible = true
            machine_type = local.gke.node_pool.machine_type
            oauth_scopes = local.gke.oauth_scopes
          }
        }
      ]
    }
  ]
}