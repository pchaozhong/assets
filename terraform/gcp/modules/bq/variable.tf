variable "bq_conf" {
  type = list(object({
    enable = bool

    dataset_conf = object({
      dataset_id = string
      location   = string
      opt_conf   = map(string)
    })

    table_conf = list(object({
      enable = bool

      table_id = string
      opt_conf = map(string)
    }))

    query_job_conf = list(object({
      enable = bool

      job_id              = string
      query               = string
      table_id            = string
      create_disposition  = string
      write_disposition   = string
      allow_large_results = bool
      flatten_results     = bool
    }))
  }))
}
