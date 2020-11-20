output "test_subnet_cidr" {
  value = data.google_compute_subnetwork.main["test"].ip_cidr_range
}

output "test_network_name" {
  value = data.google_compute_network.main["test"].name
}
