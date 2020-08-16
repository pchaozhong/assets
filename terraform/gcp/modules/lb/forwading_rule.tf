locals {
  _fd_rule = flatten([
    for _conf in var.lb_conf : [
      for _f_rule in _conf.forwarding_rule : {
        name       = _f_rule.name
        target     = _f_rule.target
        port_range = _f_rule.port_range
        ip_address = _f_rule.ip_address
      }
    ]
  ])
}

resource "google_compute_global_forwarding_rule" "main" {
  for_each = { for v in local._fd_rule : v.name => v }

  name       = each.value.name
  target     = google_compute_target_https_proxy.main[each.value.target].self_link
  port_range = each.value.port_range
  ip_address = each.value.ip_address
}
