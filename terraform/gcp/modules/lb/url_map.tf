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
  description = lookup(each.value.opt_var, "description", null)

  host_rule = lookup(each.value.opt_var, "", null)
  path_matcher = lookup(each.value.opt_var, "", null)
  test = lookup(each.value.opt_var, "", null)
  default_url_redirect = lookup(each.value.opt_var, "", null)
  default_route_action = lookup(each.value.opt_var, "", null)
  project = lookup(each.value.opt_var, "", null)

  dynamic "header_action" {
    for_each = lookup(each.value.opt_var, "header_action", false) ? [{
      request_headers_to_add = lookup(each.value.opt_var, "", null)
      request_headers_to_remove = lookup(each.value.opt_var, "", null)
      response_headers_to_add = lookup(each.value.opt_var, "", null)
      response_headers_to_remove = lookup(each.value.opt_var, "", null)
    }] : []
    content {
      request_headers_to_add = header_action.value.request_headers_to_add
      request_headers_to_remove = header_action.value.request_headers_to_remove
      response_headers_to_add = header_action.value.response_headers_to_add
      response_headers_to_remove = header_action.value.response_headers_to_remove
    }
  }
}
