locals {
  dataset_id = "github_source_data"
  table_id = "git_sample"
}

module "bq" {
  source = "../../../../../../terraform/gcp/modules/bq"

  bq_conf = [
    {
      enable = true

      dataset_conf = {
        dataset_id = local.dataset_id
        location   = "US"
        opt_conf   = {}
      }

      table_conf = [
        {
          enable = true

          table_id = local.table_id
        }
      ]

      query_job_conf = [
      ]
    }
  ]
}
