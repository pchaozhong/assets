module "iam" {
  depends_on = [ module.service_account ]
  source = "../modules/iam"

  iam_member_conf = [
    {
      iam_enable = false

      member = "module-sample"
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
      service_account_enable = false
      account_id             = "module-sample"
    }
  ]
}
