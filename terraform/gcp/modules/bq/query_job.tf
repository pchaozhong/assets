locals {
  _query_job_conf = flatten([
    for _conf in var.bq_conf : [
      for _query_conf in _conf.query_job_conf : {
        job_id              = _query_conf.job_id
        query               = _query_conf.query
        table_id            = _query_conf.table_id
        create_disposition  = _query_conf.create_disposition
        write_disposition   = _query_conf.write_disposition
        allow_large_results = _query_conf.allow_large_results
        flatten_results     = _query_conf.flatten_results
        location            = _conf.dataset_conf.location
        dataset_id          = _conf.dataset_conf.dataset_id
      } if _query_conf.enable
    ] if _conf.enable
  ])
}

resource "google_bigquery_job" "query_job" {
  for_each = { for v in local._query_job_conf : v.job_id => v }

  job_id   = each.value.job_id
  location = each.value.location

  query {
    query = each.value.query

    destination_table {
      table_id   = google_bigquery_table.main[each.value.table_id].id
      dataset_id = google_bigquery_dataset.main[each.value.dataset_id].id
    }

    create_disposition  = each.value.create_disposition
    write_disposition   = each.value.write_disposition
    allow_large_results = each.value.allow_large_results
    flatten_results     = each.value.flatten_results
  }
}
