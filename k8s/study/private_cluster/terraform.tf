provider "google" {
  project = terraform.workspace
  region  = local.location.region
  zone = local.location.zone
}

provider "google-beta" {
  project = terraform.workspace
  region  = local.location.region
  zone = local.location.zone
}

locals {
  location = {
    region = "asia-northeast1"
    zone = "asia-northeast1-b"
  }
}
