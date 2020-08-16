locals {
  _bk_service = flatten([
    for _conf in lb_conf : [
      for _bk_conf in _conf.bk_service : {
        name                   = _bk_conf.name
        health_checks          = _bk_conf.health_checks
        protocol               = _bk_conf.protocol
        timeout_sec            = _bk_conf.timeout_sec
        instance_group_manager = _bk_conf.instance_group_manager
      }
    ]
  ])
}

resource "google_compute_backend_service" "main" {
  for_each = { for v in local._bk_service : v.name => v }

  name          = each.value.name
  health_checks = each.value.health_checks
  protocol      = each.value.protocol
  timeout_sec   = each.value.timeout_sec

  backend {
    group = google_compute_instance_group_manager.main[each.value.instance_group_manager].intance_group
  }
}
