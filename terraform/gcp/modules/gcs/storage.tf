locals {
  _storage_conf = flatten([
    for _conf in var.gcs_conf.storage_conf : _conf if var.gcs_conf.enable && _conf.enable
  ])
}

resource "google_storage_bucket" "main" {
  for_each = { for v in local._storage_conf : v.name => v }

  name          = each.value.name
  location      = each.value.location
  force_destroy = each.value.force_destroy

  bucket_policy_only = each.value.bucket_policy_only

  dynamic "lifecycle_rule" {
    for_each = each.value.lifecycle_rule.enable ? [{
      age  = each.value.lifecycle_rule.age
      type = each.value.lifecycle_rule.type
    }] : []
    content {
      condition {
        age = lifecycle_rule.value.age
      }
      action {
        type = lifecycle_rule.value.type
      }
    }
  }
}
