module "gcf" {
  source = "../modules/gcf"

  glue_conf = [
    {
      enable = false

      gcf_conf = {
        name = ""
        runtime = ""
        environment_variables = {}
        opt_var = {}
      }

      pubsub_conf = []
      gcs_conf = []
    }
  ]
}
