locals {
  _object_conf = flatten([
    for _conf in var.gcs_conf.storage_conf : [
      for _obj_conf in _conf.object_conf : {
        name     = _obj_conf.name
        source   = _obj_conf.source
        bucket   = _conf.name
        opt_conf = _obj_conf.opt_conf
      } if _conf.enable
    ] if var.gcs_conf.enable
  ])
}

resource "google_storage_bucket_object" "main" {
  for_each = { for v in local._object_conf : v.name => v }

  name                = each.value.name
  bucket              = each.value.bucket
  source              = each.value.source
  cache_control       = lookup(each.value.opt_conf, "cache_control", null)
  content_disposition = lookup(each.value.opt_conf, "content_disposition", null)
  content_encoding    = lookup(each.value.opt_conf, "content_encoding", null)
  content_language    = lookup(each.value.opt_conf, "content_language", null)
  content_type        = lookup(each.value.opt_conf, "content_type", null)
  storage_class       = lookup(each.value.opt_conf, "storage_class", null)
}
