variable "service_account_conf" {
  type = list(object({
    account_id = string
  }))
}

output "service_accout_email" {
  value = length(var.service_account_conf) != 0 ? { for v in google_service_account.main : v.account_id => v.email} : null
}

resource "google_service_account" "main" {
  for_each = { for v in var.service_account_conf : v.account_id => v}

  account_id   = each.value.account_id
}
