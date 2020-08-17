locals {
  _sa_list = flatten([
    for _conf in var.iam_member_conf : {
      id = _conf.member
    } if _conf.member_type == "serviceAccount" && _conf.iam_enable
  ])
}

data "google_service_account" "main" {
  for_each = { for v in local._sa_list : v.id => v }

  account_id = each.value.id
}
