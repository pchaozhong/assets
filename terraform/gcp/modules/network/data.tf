locals {
  _ilb_list = compact(distinct(flatten([
    for _conf in var.network_conf : [
      for _rt_conf in _conf.route_conf : lookup(_rt_conf, "next_hop_ilb", "")
    ]
  ])))

  _gce_list = compact(distinct(flatten([
    for _conf in var.network_conf : [
      for _rt_conf in _conf.route_conf : lookup(_rt_conf, "next_hop_instance", "")
    ]
  ])))
}

data "google_compute_forwarding_rule" "main" {
  for_each = toset(local._ilb_list)

  name = each.value
}
