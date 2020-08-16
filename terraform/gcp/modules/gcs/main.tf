variable "storage_bucket" {
  type = list(object({
    name               = string
    location           = string
    force_destroy      = bool
    bucket_policy_only = bool
    lifecycle_rule = list(object({
      age  = string
      type = string
    }))
  }))
}

resource "google_storage_bucket" "main" {
  for_each = { for v in var.storage_bucket : v.name => v }

  name          = each.value.name
  location      = each.value.location
  force_destroy = each.value.force_destroy

  bucket_policy_only = each.value.bucket_policy_only

  dynamic "lifecycle_rule" {
    for_each = each.value.lifecycle_rule
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
