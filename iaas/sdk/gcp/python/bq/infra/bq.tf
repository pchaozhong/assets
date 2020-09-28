module "bq" {
  source = "../../../../../../terraform/gcp/modules/bq"

  bq_conf = [
    {
      enable = true

      dataset_conf = {
        dataset_id = "github_source_data"
        location   = "US"
        opt_conf   = {}
      }

      table_conf = [
        {
          enable = true

          table_id = "git_sample"
        }
      ]

      query_job_conf = [
      ]
    }
  ]
}
