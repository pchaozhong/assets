output "network_self_link" {
  value = var.vpc_enabled ? google_compute_network.main[0].self_link : null
}

output "subnetwork_self_link" {
  value = var.vpc_enabled ? google_compute_subnetwork.main[0].self_link : null
}
