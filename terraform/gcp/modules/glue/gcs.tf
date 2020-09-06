locals {
  _gcs_conf = distinct(flatten([
    for _conf in var.glue_conf : [
      for _g_conf in _conf.gcs_conf : _g_conf if _g_conf.enable
    ] if _conf.enable
  ]))
}

resource "google_storage_bucket" "main" {
  for_each = { for v in local._gcs_conf : v.name => v}

  name = each.value.name
  location = each.value.location
  force_destroy = lookup(each.value.opt_conf, "force_destroy", true)
}
