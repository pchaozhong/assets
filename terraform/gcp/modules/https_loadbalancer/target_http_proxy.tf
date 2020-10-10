locals {
  _target_http_proxy_conf = flatten([
    for _conf in var.https_loadbalancer_conf.target_http_proxy_conf : _conf if _conf.enable && var.https_loadbalancer_conf.enable
  ])
}

resource "google_compute_target_http_proxy" "main" {
  for_each = { for v in local._target_http_proxy_conf : v.name => v }

  name    = each.value.name
  url_map = google_compute_url_map.main[each.value.url_map].id
}
