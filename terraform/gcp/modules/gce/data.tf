locals {
  _service_account_list = distinct(flatten([
    for _conf in var.gce_conf : _conf.service_account.email if _conf.gce_enable
  ]))

  _nw_list = distinct(flatten([
    for _conf in var.gce_conf : {
      name   = _conf.subnetwork
      region = _conf.region
    } if _conf.gce_enable
  ]))
}

data "google_compute_subnetwork" "main" {
  for_each = { for v in local._nw_list : v.name => v }

  name   = each.value.name
  region = each.value.region
}

data "google_service_account" "main" {
  for_each = toset(local._service_account_list)

  account_id = each.value
}
