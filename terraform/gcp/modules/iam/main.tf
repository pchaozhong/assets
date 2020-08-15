locals {
  _iam_member_conf = flatten([
    for _conf in var.iam_member_conf : [
      for _role in _conf.role : {
        id     = join("-", [split("@", _conf.member)[0], split("/", _role)[1]])
        member = join(":", [_conf.member_type, _conf.member])
        role   = _role
      }
    ]
  ])
}

variable "iam_member_conf" {
  type = list(object({
    role        = list(string)
    member      = string
    member_type = string
  }))
}

resource "google_project_iam_member" "main" {
  for_each = { for v in local._iam_member_conf : v.id => v }

  role   = each.value.role
  member = each.value.member
}
