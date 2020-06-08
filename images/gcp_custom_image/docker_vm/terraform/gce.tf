locals {
  image = "docker-ubuntu"
  nw    = "default"
}

variable "machine_type" {
  type    = string
  default = "f1-micro"
}

resource "google_compute_instance" "docker" {
  name         = "docker"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = local.image
    }
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  network_interface {
    network = local.nw
    access_config {

    }
  }
}
