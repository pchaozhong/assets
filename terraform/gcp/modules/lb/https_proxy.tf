locals {
  _thp_conf = flatten([
    for _conf in var.lb_conf : [
      for _thp in _conf.tgt_https_proxy : {
        name             = _thp.name
        url_map          = _conf.url_map
        ssl_certificates = _thp.ssl_certificates
      }
    ]
  ])
}

resource "google_compute_target_https_proxy" "main" {
  for_each = { for v in local._thp_conf : v.name => v }

  name             = each.value.name
  url_map          = google_compute_url_map.main[each.value.url_map].self_link
  ssl_certificates = each.value.ssl_certs
}
