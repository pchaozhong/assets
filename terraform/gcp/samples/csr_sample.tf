module "csr" {
  source = "../modules/csr"

  csr_conf = [
    {
      name = "test"
      pubsub_configs = []
    }
  ]
}
