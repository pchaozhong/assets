locals {
  _iam_member_conf = flatten([
    for _conf in var.iam_member_conf : [
      for _role in _conf.role : {
        id     = join("-", [split("@", _conf.member)[0], split("/", _role)[1]])
        member = _conf.member_type != "serviceAccount" ? join(":", [_conf.member_type, _conf.member]) : join(":", [_conf.member_type, data.google_service_account.main[_conf.member].email])
        role   = _role
      }
    ] if _conf.enable
  ])
}

variable "iam_member_conf" {
  type = list(object({
    enable = bool

    member      = string
    member_type = string
    role        = list(string)
  }))
}

resource "google_project_iam_member" "main" {
  for_each = { for v in local._iam_member_conf : v.id => v }

  role   = each.value.role
  member = each.value.member
}
