module "iam" {
  source = "../modules/iam"

  iam_member_conf = [
    {
      member = module.service_account.service_accout_email.module-sample
      member_type = "serviceAccount"
      role = [
        "roles/editor"
      ]
    },
  ]
}


module "service_account" {
  source = "../modules/service_account"

  service_account_conf = [
    {
      account_id = "module-sample"
    }
  ]
}
