locals {
  network = [
    "test"
  ]
  subnetwork = [
    {
      name = "test"
      region = "asia-northeast1"
    }
  ]
}

data "google_compute_subnetwork" "main" {
  for_each = { for v in local.subnetwork : v.name => v}

  name = each.value.name
  region = each.value.region
}

data "google_compute_network" "main" {
  for_each = toset(local.network)
  name = each.value
}
