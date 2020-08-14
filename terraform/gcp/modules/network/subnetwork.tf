resource "google_compute_subnetwork" "main" {
  for_each = { for v in var.subnetwork_conf : v.name => v}

  name          = each.value.name
  network       = google_compute_network.main[each.value.vpc_network].self_link
  ip_cidr_range = each.value.cidr
  region        = each.value.region
}
