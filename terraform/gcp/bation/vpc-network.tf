resource "google_compute_network" "bastion" {
  name                    = "bastion"
  auto_create_subnetworks = false
}
