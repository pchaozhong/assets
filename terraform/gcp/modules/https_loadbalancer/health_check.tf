locals {
  _health_check_conf = flatten([
    for _conf in var.https_loadbalancer_conf.health_check_conf : _conf if _conf.enable && var.https_loadbalancer_conf.enable
  ])
}

resource "google_compute_health_check" "main" {
  for_each = { for v in local._health_check_conf : v.name => v }

  name                = each.value.name
  healthy_threshold   = each.value.healthy_threshold
  timeout_sec         = each.value.timeout_sec
  check_interval_sec  = each.value.check_interval_sec
  unhealthy_threshold = each.value.unhealthy_threshold

  dynamic "http_health_check" {
    for_each = each.value.http_health_check.enable ? [{
      port_name    = each.value.http_health_check.port_name
      host         = each.value.http_health_check.host
      request_path = each.value.http_health_check.request_path
    }] : []
    content {
      port_name    = http_health_check.value.port_name
      host         = http_health_check.value.host
      request_path = http_health_check.value.request_path
    }
  }
}
