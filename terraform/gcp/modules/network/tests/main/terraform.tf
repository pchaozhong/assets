terraform {
  required_version = "~> 0.13"
  backend "gcs" {
    bucket = "ca-kitano-study-terraform-modules-state"
    prefix = "network"
  }
}

provider "google" {
  project = terraform.workspace
}

provider "google-beta" {
  project = terraform.workspace
}
