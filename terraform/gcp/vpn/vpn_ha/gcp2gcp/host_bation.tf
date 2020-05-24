resource "google_compute_instance" "host-bation" {
  name = "host-bation"
  machine_type = "f1-micro"
  zone = "asia-northeast1-b"

  tags = ["bation"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.demohost.name

    access_config {
      
    }
  }
}

resource "google_compute_firewall" "host-fw" {
  name = "host-bation"
  network = google_compute_network.demohost.name

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

resource "google_compute_route" "host-rt" {
  name = "host-route"
  dest_range = "192.168.1.0/24"
  network = google_compute_network.demohost.name
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.host-tunnel1.self_link
}
