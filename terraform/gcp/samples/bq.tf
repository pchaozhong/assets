module "bq" {
  source = "../modules/bq"

  bq_conf = [
    {
      enable = false

      dataset_conf = {
        dataset_id = "github_source_data"
        location = "asia-northeast1"
        opt_conf = {}
      }

      table_conf = [
        {
          enable = true

          table_id = "git_sample"
        }
      ]
    }
  ]
}
