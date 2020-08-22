data "google_compute_subnetwork" "test" {
  name = "test"
  region = "asia-northeast1"
}

data "google_compute_network" "test" {
  name = "test"
}
