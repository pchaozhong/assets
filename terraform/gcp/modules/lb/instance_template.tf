locals {
  _instance_template = flatten([
    for _conf in var.lb_conf : [
      for _ist_tmp in _conf.instance_template : {
        name_prefix           = _conf.instance_template
        machine_type          = _ist_tmp.machine_type
        source_image          = _ist_tmp.source_image
        auto_delete           = _ist_tmp.auto_delete
        access_config         = _ist_tmp.access_config
        create_before_destroy = _ist_tmp.create_before_destroy
      }
    ]
  ])
}

resource "google_compute_instance_template" "main" {
  for_each = { for v in local._instance_template : v.name_prefix => v }

  name_prefix  = each.value.name_prefix
  machine_type = each.value.machine_type
  tags         = each.value.tags

  disk {
    source_image = each.value.source_image
    auto_delete  = each.value.auto_delete
  }

  network_interface {
    subnetwork = each.value.subnetwork
    dynamic "access_config" {
      for_each = each.value.access_config
      content {

      }
    }
  }

  lifecycle {
    create_before_destroy = each.value.create_before_destroy
  }
}
