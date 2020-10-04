locals {
  _instance_group_manager_conf = flatten([
    for _conf in var.https_loadbalancer_conf.instance_group_manager_conf : _conf if var.https_loadbalancer_conf.enable && _conf.enable
  ])
}

resource "google_compute_instance_group_manager" "main" {
  for_each = { for v in local._instance_group_manager_conf : v.name => v }
  provider = google-beta

  name               = each.value.name
  base_instance_name = each.value.base_instance_name
  zone               = each.value.zone
  description        = each.value.description
  target_size        = each.value.target_size


  dynamic "update_policy" {
    for_each = lookup(each.value.opt_conf, "update_policy", false) ? [{
      type              = lookup(each.value.opt_conf, "type", null)
      minimal_action    = lookup(each.value.opt_conf, "minimal_action", null)
      max_surge_percent = lookup(each.value.opt_conf, "max_surge_percent", null)
      min_ready_sec     = lookup(each.value.opt_conf, "min_ready_sec", null)
    }] : []
    content {
      type              = update_policy.value.type
      minimal_action    = update_policy.value.minimal_action
      max_surge_percent = update_policy.value.max_surge_percent
      min_ready_sec     = update_policy.value.min_ready_sec
    }
  }

  dynamic "version" {
    for_each = { for _conf in each.value.version : _conf.name => _conf }
    content {
      name              = version.value.name
      instance_template = google_compute_instance_template.main[version.value.instance_template].id
      dynamic "target_size" {
        for_each = version.value.target_size.enable ? [{
          fixed   = version.value.target_size.fixed_enable ? version.value.target_size.fixed : null
          percent = version.value.target_size.percent_enable ? version.value.target_size.percent : null
        }] : []
        content {
          fixed   = target_size.value.fixed
          percent = target_size.value.percent
        }
      }
    }
  }
}
