locals {
  _gcs_conf = distinct(flatten([
    for _conf in var.glue_conf : [
      for _g_conf in _conf.gcs_conf : _g_conf if _g_conf.enable
    ] if _conf.enable
  ]))
}

resource "google_storage_bucket" "main" {
  for_each = toset(local._gcs_conf)

  name = each.value.name
  location = each.value.location
}
