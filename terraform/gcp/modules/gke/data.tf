locals {
  _nw_list = flatten([
    for _conf in var.gke_conf : [
      for _cluster in _conf.cluster : {
        name = _cluster.network
      }
    ]
  ])

  _subnet_list = flatten([
    for _conf in var.gke_conf : [
      for _cluster in _conf.cluster : {
        name   = _cluster.subnetwork
        region = _cluster.location
      }
    ]
  ])
}

data "google_compute_subnetwork" "main" {
  for_each = { for v in local._subnet_list : v.name => v }

  name   = each.value.name
  region = each.value.region
}

data "google_compute_network" "main" {
  for_each = { for v in local._nw_list : v.name => v }

  name = each.value.name
}
