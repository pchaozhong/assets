terraform{
  required_version = "~> 0.12"
}

provider "google" {
  project = terraform.workspace
  region  = "asia-northeast1"
  zone    = "asia-northeast1-b"
}

provider "google-beta" {
  project = terraform.workspace
  region  = "asia-northeast1"
  zone    = "asia-northeast1-b"
}
