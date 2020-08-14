output "network_self_link" {
  value = length(var.vpc_network_conf) != 0 ? { for v in google_compute_network.main : v.name => v.self_link} : null
}

output "subnetwork_self_link" {
  value = length(var.subnetwork_conf) != 0 ? { for v in google_compute_subnetwork.main : v.name => v.self_link} : null
}
