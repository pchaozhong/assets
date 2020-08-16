locals {
  _igm_conf = flatten([
    for _conf in var.lb_conf : [
      for _img in _conf.grp_mng : {
        name               = _img.name
        zone               = _conf.zone
        target_size        = _img.target_size
        instance_template  = _conf.instance_template
        base_instance_name = _img.base_instance_name
      }
    ]
  ])
}

resource "google_compute_instance_group_manager" "main" {
  for_each = { for v in local._img_conf : v.name => v }

  name               = each.value.name
  instance_template  = google_compute_instance_template.main[each.value.instance_template].self_link
  zone               = each.value.zone
  base_instance_name = each.value.base_instance_name
  target_size        = each.value.target_size
}
