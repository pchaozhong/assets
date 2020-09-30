locals {
  _service_account_conf = flatten([
    for _conf in var.service_account_conf : {
      account_id = _conf.account_id
    } if _conf.enable
  ])
}

variable "service_account_conf" {
  type = list(object({
    enable = bool

    account_id = string
  }))
}

output "service_accout_email" {
  value = { for v in google_service_account.main : v.account_id => v.email }
}

resource "google_service_account" "main" {
  for_each = { for v in local._service_account_conf : v.account_id => v }

  account_id = each.value.account_id
}
