locals {
  zone   = "asia-northeast1-b"
  region = "asia-northeast1"
  network = "module-test"
  subnetwork = {
    name = "module-test"
    cidr = "192.168.0.0/24"
  }
}
