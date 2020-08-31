module "gcf" {
  source = "../modules/gcf"

  gcf_conf = [
    {
      gcf_enable = false

      name    = "test"
      runtime = "go113"
      environment_variables = {}
      opt_var = {}
    }
  ]
}
