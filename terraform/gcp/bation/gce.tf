resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.bastion.self_link
    access_config {
      
    }
  }
}
