output "test_sbnw_cidr" {
  value = data.google_compute_subnetwork.test.ip_cidr_range
}

output "test_nw_name" {
  value = data.google_compute_network.test.name
}
