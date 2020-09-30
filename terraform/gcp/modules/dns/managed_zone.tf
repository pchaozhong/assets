locals {
  _dns_zone_conf = flatten([
    for _conf in var.dns_conf : [
      for _zone_conf in _conf.mng_zone : {
        name                      = _conf.zone_name
        dns_name                  = _zone_conf.dns_name
        visibility                = _zone_conf.visibility
        private_visibility_config = _zone_conf.private_visibility_config
        forwarding_config         = _zone_conf.forwarding_config
      } if _conf.dns_zone_enable
    ]
  ])
}

resource "google_dns_managed_zone" "main" {
  for_each = { for v in local._dns_zone_conf : v.name => v }

  depends_on = [google_project_service.main]
  provider   = "google-beta"

  name       = each.value.name
  dns_name   = each.value.dns_name
  visibility = each.value.visibility

  dynamic "private_visibility_config" {
    for_each = each.value.private_visibility_config
    content {
      networks {
        network_url = data.google_compute_network.main[private_visibility_config.value.network].self_link
      }
    }
  }

  dynamic "forwarding_config" {
    for_each = each.value.forwarding_config
    content {
      target_name_servers {
        ipv4_address = forwarding_config.value.ipv4_address
      }
    }
  }
}
