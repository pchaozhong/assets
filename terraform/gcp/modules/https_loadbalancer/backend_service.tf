locals {
  _backend_service_conf = flatten([
    for _conf in var.https_loadbalancer_conf.backend_service_conf : _conf if _conf.enable && var.https_loadbalancer_conf.enable
  ])
}

resource "google_compute_backend_service" "main" {
  for_each = { for v in local._backend_service_conf : v.name => v }

  name     = each.value.name
  protocol = each.value.protocol

  health_checks = [
    google_compute_health_check.main[each.value.health_check].self_link
  ]

  backend {
    group = google_compute_instance_group_manager.main[each.value.instnce_group].instance_group
  }
}

