locals {
  _url_map_conf = flatten([
    for _conf in var.https_loadbalancer_conf.url_map_conf : _conf if _conf.enable && var.https_loadbalancer_conf.enable
  ])
}

resource "google_compute_url_map" "main" {
  for_each = { for v in local._url_map_conf : v.name => v }

  name            = each.value.name
  default_service = google_compute_backend_service.main[each.value.backend_service].id
}
