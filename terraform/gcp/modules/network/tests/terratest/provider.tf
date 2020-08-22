terraform {
  required_version = "~> 0.13"
}

provider "google" {
  project = terraform.workspace
}

provider "google-beta" {
  project = terraform.workspace
}
