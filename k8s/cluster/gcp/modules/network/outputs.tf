output "network_self_link" {
  value = var.vpc_enabled ? google_compute_network.main[0].self_link : null
}

output "subnetwork_self_links" {
  value = var.vpc_enabled ? { for k, v in google_compute_subnetwork.main : k => v["self_link"] } : null
}
