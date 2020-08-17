module "csr" {
  source = "../modules/csr"

  csr_conf = [
    {
      csr_enable = false

      name           = "test"
      pubsub_configs = []
    }
  ]
}
