data "google_compute_subnetwork" "main" {
  for_each = { for v in local._nw_list : v.name => v }

  name   = each.value.name
  region = each.value.region
}
