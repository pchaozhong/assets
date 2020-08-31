module "gcs" {
  source = "../modules/gcs"

  storage_bucket = [
    {
      gcs_enable = false

      name               = "ca-kitano-study-sandbox-demo2"
      location           = "US"
      force_destroy      = true
      bucket_policy_only = true
      lifecycle_rule     = []
    }
  ]
}
