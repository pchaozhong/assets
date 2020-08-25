module "gce" {
  depends_on = [
    module.network,
    module.iam,
    module.service_account
  ]
  source     = "../modules/gce"

  gce_conf = yamldecode(file("./files/gce.yaml"))
}

