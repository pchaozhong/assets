provider "google" {
  project = terraform.workspace
  region  = "asia-northeast1"
}

provider "google-beta" {
  project = terraform.workspace
  region  = "asia-northeast1"
}
