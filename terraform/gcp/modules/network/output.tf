output "network_self_link" {
  value = { for v in google_compute_network.main : v.name => v.self_link }
}

output "subnetwork_self_link" {
  value = { for v in google_compute_subnetwork.main : v.name => v.self_link }
}
