locals {
  _table_conf = flatten([
    for _conf in var.bq_conf : [
      for _tb_conf in _conf.table_conf : {
        dataset_id = _conf.dataset_conf.dataset_id
        table_id   = _tb_conf.table_id
        opt_conf   = _tb_conf.opt_conf
      } if _tb_conf.enable
    ] if _conf.enable
  ])
}

resource "google_bigquery_table" "main" {
  for_each = { for v in local._table_conf : v.table_id => v }

  dataset_id = google_bigquery_dataset.main[each.value.dataset_id].dataset_id
  table_id   = each.value.table_id
  schema     = lookup(each.value.opt_conf, "schema", null)

  dynamic "time_partitioning" {
    for_each = lookup(each.value.opt_conf, "time_partitioning", false) ? [{
      expiration_ms            = lookup(each.value.opt_conf, "time_partitioning_expiration_ms", null)
      field                    = lookup(each.value.opt_conf, "time_partitioning_field", null)
      type                     = lookup(each.value.opt_conf, "time_partitioning_type", "DAY")
      require_partition_filter = lookup(each.value.opt_conf, "time_partitioning_require_partition_filter", true)
    }] : []
    content {
      expiration_ms            = time_partitioning.value.expiration_ms
      field                    = time_partitioning.value.field
      type                     = time_partitioning.value.type
      require_partition_filter = time_partitioning.value.require_partition_filter
    }
  }
}
