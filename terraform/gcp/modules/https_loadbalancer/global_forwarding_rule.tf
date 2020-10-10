locals {
  _global_forwading_rule_conf = flatten([
    for _conf in var.https_loadbalancer_conf.global_forwarding_rule_conf : _conf if _conf.enable && var.https_loadbalancer_conf.enable
  ])
}

resource "google_compute_global_forwarding_rule" "main" {
  for_each = { for v in local._global_forwading_rule_conf : v.name => v }

  name       = each.value.name
  target     = google_compute_target_http_proxy.main[each.value.target].id
  port_range = each.value.port_range
}
