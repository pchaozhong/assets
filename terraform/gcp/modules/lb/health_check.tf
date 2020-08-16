locals {
  _hc_conf = flatten([
    for _conf in var.lb_conf : [
      for _hc in _conf.health_check : {
        name               = _hc.name
        http_health_check  = _hc.http_health_check
        https_health_check = _hc.https_health_check
      }
    ]
  ])
}

resource "google_compute_health_check" "main" {
  for_each = { for v in local._hc_conf : v.name => v }

  name = each.value.name

  dynamic "http_health_check" {
    for_each = each.value.http_health_check
    content {
      request_path = http_health_check.value.request_path
      port         = http_health_check.value.port
    }
  }

  dynamic "https_health_check" {
    for_each = each.value.https_health_check
    content {
      request_path = https_health_check.value.request_path
      port         = https_health_check.value.port
    }
  }
}
