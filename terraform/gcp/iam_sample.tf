module "iam" {
  source = "./modules/iam"

  iam_member_conf = [
    {
      member = "test@test"
      member_type = "user"
      role = [
        "roles/editor"
      ]
    }
  ]
}
