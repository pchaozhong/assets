terraform{
  required_version = "~> 0.12"
  backend "gcs" {
    bucket = "ca-kitano-study-sandbox-tffile"
    prefix = "assets-bation"
  }
}
