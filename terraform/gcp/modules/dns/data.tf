locals {
  _nw_list = flatten([
    for _conf in var.dns_conf : [
      for _mng_conf in _conf.mng_zone : [
        for _nw in _mng_conf.private_visibility_config : {
          name = _nw.network
        }
      ]
    ] if _conf.dns_zone_enable
  ])
}

data "google_compute_network" "main" {
  for_each = { for v in local._nw_list : v.name => v}

  name = each.value.name
}
