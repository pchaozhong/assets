data "google_compute_subnetwork" "main" {
  for_each = { for v in local._nw_list : v.name => v }

  name   = each.value.name
  region = each.value.region
}

data "google_service_account" "main" {
  for_each = toset(local._service_account_list)

  account_id = each.value
}
