module "iam" {
  depends_on = [ module.service_account ]
  source = "../modules/iam"

  iam_member_conf = yamldecode(file("./files/iam_sample.yaml"))
}

module "service_account" {
  source = "../modules/service_account"

  service_account_conf = yamldecode(file("./files/service_account_sample.yaml"))
}
