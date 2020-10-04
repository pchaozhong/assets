locals {
  _service_account_conf = distinct(flatten([
    for _conf in var.https_loadbalancer_conf.instance_template_conf : _conf.email if var.https_loadbalancer_conf.enable && _conf.enable
  ]))

  _subnetwork_list = distinct(flatten([
    for _conf in var.https_loadbalancer_conf.instance_template_conf : _conf if var.https_loadbalancer_conf.enable && _conf.enable
  ]))
}

data "google_service_account" "main" {
  for_each = toset(local._service_account_conf)

  account_id = each.value
}

data "google_compute_subnetwork" "main" {
  for_each = { for v in local._subnetwork_list : v.subnetwork => v }

  name   = each.value.subnetwork
  region = each.value.region
}
