resource "google_compute_instance" "guest-bation" {
  name = "guest-bation"
  machine_type = "f1-micro"
  zone = "asia-northeast1-b"

  tags = ["bation"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.demoguest.name

    access_config {

    }
  }
}

resource "google_compute_firewall" "guest-fw" {
  name = "guest-bation"
  network = google_compute_network.demoguest.name

  target_tags = [
    "bation"
  ]
  allow {
    protocol = "tcp"
    ports = var.bation
  }
  allow {
    protocol = "icmp"
  }
}

resource "google_compute_route" "guest-rt" {
  name = "guest-route"
  dest_range = "192.168.0.0/24"
  network = google_compute_network.demoguest.name
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.guest-tunnel1.self_link
}
