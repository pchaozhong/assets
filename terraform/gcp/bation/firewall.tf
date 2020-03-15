resource "google_compute_firewall" "bastion" {
  name    = "allow-ssh"
  network = google_compute_network.bastion.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
