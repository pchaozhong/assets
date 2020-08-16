locals {
  _url_map_conf = flatten([
    for _conf in var.lb_conf : [
      for _url_map in _conf.url_map : {
        name            = _conf.url_map
        default_service = _url_map.default_service
      }
    ]
  ])
}

resource "google_compute_url_map" "main" {
  for_each = { for v in local._url_map_conf : v.name => v }

  name            = each.value.name
  default_service = google_compute_backend_service.main[each.value.backend_service].self_link
}
