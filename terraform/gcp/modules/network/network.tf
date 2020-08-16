locals {
  _nw_conf = flatten([
    for _conf in var.network_conf : _conf.vpc_network_conf if _conf.vpc_network_enable
  ])

  _subnet_tmp_list = flatten([
    for _conf in var.network_conf : _conf.subnetwork if _conf.subnetwork_enable
  ])

  _subnetwork_conf = flatten([
    for _nw in local._nw_conf : [
      for _subnet in local._subnet_tmp_list : {
        name = _subnet.name
        cidr = _subnet.cidr
        region = _subnet.region
        vpc_network = _nw.name
      }
    ]
  ])
}

resource "google_compute_network" "main" {
  for_each = { for v in local._nw_conf : v.name => v }

  name                    = each.value.name
  auto_create_subnetworks = each.value.auto_create_subnetworks
}

resource "google_compute_subnetwork" "main" {
  for_each = { for v in local._subnetwork_conf : v.name => v }

  name          = each.value.name
  network       = google_compute_network.main[each.value.vpc_network].self_link
  ip_cidr_range = each.value.cidr
  region        = each.value.region
}
