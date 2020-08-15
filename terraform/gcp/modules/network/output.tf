output "network_self_link" {
  value = length(var.network_conf) != 0 ? { for v in google_compute_network.main : v.name => v.self_link} : null
}

output "subnetwork_self_link" {
  value = length(local._subnetwork_conf_list) != 0 ? { for v in google_compute_subnetwork.main : v.name => v.self_link} : null
}
