terraform {
  required_version = "~> 0.13"
}

provider "google" {
  project = "ca-kitano-study-sandbox"
}

provider "google-beta" {
  project = "ca-kitano-study-sandbox"
}
