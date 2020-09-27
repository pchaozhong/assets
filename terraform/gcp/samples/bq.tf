module "bq" {
  source = "../modules/bq"

  bq_conf = [
    {
      enable = false

      dataset_conf = {
        dataset_id = "github_source_data"
        location   = "asia-northeast1"
        opt_conf   = {}
      }

      table_conf = [
        {
          enable = true

          table_id = "git_sample"
        }
      ]

      query_job_conf = [
        {
          enable = true

          job_id              = "github_repos_commit_query"
          query               = file("./files/query_job.sql")
          table_id            = "git_sample"
          create_disposition  = null
          write_disposition   = null
          allow_large_results = true
          flatten_results     = true
        }
      ]
    }
  ]
}
