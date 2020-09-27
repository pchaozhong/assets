locals {
  _table_conf = flatten([
    for _conf in var.bq_conf : [
      for _tb_conf in _conf.table_conf : {
        dataset_id = _conf.dataset_conf.dataset_id
        table_id   = _tb_conf.table_id
      } if _tb_conf.enable
    ] if _conf.enable
  ])
}

resource "google_bigquery_table" "main" {
  for_each = { for v in local._table_conf : v.table_id => v }

  dataset_id = google_bigquery_dataset.main[each.value.dataset_id].dataset_id
  table_id   = each.value.table_id
}
