resource "google_compute_network" "main" {
  for_each = { for v in var.vpc_network_conf : v.name => v }

  name                    = each.value.name
  auto_create_subnetworks = each.value.auto_create_subnetworks
}

