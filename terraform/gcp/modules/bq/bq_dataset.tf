locals {
  _dataset_conf = flatten([
    for _conf in var.bq_conf : _conf.dataset_conf if _conf.enable
  ])
}

resource "google_bigquery_dataset" "main" {
  for_each = { for v in local._dataset_conf : v.dataset_id => v }

  dataset_id = each.value.dataset_id
  location   = each.value.location

  project                     = lookup(each.value.opt_var, "project", terraform.workspace)
  friendly_name               = lookup(each.value.opt_var, "friendly_name", null)
  description                 = lookup(each.value.opt_var, "description", null)
  default_table_expiration_ms = lookup(each.value.opt_var, "default_table_expiration_ms", null)

  dynamic "access" {
    for_each = lookup(each.value.opt_var, "access", false) ? [{
      domain         = lookup(each.value.opt_var, "domain", null)
      group          = lookup(each.value.opt_var, "group", null)
      group_by_email = lookup(each.value.opt_var, "group_by_email", null)
      role           = lookup(each.value.opt_var, "role", null)
      special_group  = lookup(each.value.opt_var, "special_group", null)
      user_by_email  = lookup(each.value.opt_var, "user_by_email", null)
      view           = lookup(each.value.opt_var, "view", false)
    }] : []
    content {
      domain         = access.value.domain
      group          = access.value.group
      group_by_email = access.value.group_by_email
      role           = access.value.role
      special_group  = access.value.special_group
      user_by_email  = access.value.user_by_email

      dynamic "view" {
        for_each = access.value.view ? [{
          dataset_id = lookup(each.value.opt_var, "dataset_id", null)
          project_id = lookup(each.value.opt_var, "project_id", null)
          table_id   = lookup(each.value.opt_var, "table_id", null)
        }] : []
        content {
          dataset_id = view.value.dataset_id
          project_id = view.value.project_id
          table_id   = view.value.table_id
        }
      }
    }
  }
}
