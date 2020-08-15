locals {
  _subnetwork_conf_list = flatten([
    for _conf in var.network_conf : [
      for _subnet_conf in _conf.subnetwork : {
        name = _subnet_conf.name
        cidr = _subnet_conf.cidr
        region = _subnet_conf.region
        vpc_network = _conf.vpc_network
      }
    ]
  ])
}

variable "network_conf" {
  type = list(object({
    vpc_network = string
    auto_create_subnetworks = bool
    subnetwork = list(object({
      name = string
      cidr = string
      region = string
    }))
  }))
}

resource "google_compute_network" "main" {
  for_each = { for v in var.network_conf : v.vpc_network => v }

  name                    = each.value.vpc_network
  auto_create_subnetworks = each.value.auto_create_subnetworks
}

resource "google_compute_subnetwork" "main" {
  for_each = { for v in local._subnetwork_conf_list : v.name => v }

  name          = each.value.name
  network       = google_compute_network.main[each.value.vpc_network].self_link
  ip_cidr_range = each.value.cidr
  region        = each.value.region
}
