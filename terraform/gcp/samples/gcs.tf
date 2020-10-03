module "gcs" {
  source = "../modules/gcs"

  gcs_conf = {
    enable = false

    storage_conf = [
      {
        enable = true

        name               = join("-", [terraform.workspace, "terraform-module-sample"])
        location           = "US"
        force_destroy      = true
        bucket_policy_only = true
        lifecycle_rule = {
          enable = false
          age    = null
          type   = null
        }

        object_conf = [
          {
            enable = true

            name     = "object_test.txt"
            source   = "./files/object_test.txt"
            opt_conf = {}
          }
        ]
      }
    ]
  }
}
