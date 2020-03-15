resource "google_compute_subnetwork" "bastion" {
  name = "bastion"
  ip_cidr_range = "192.168.10.0/28"
  network = google_compute_network.bastion.self_link
}
