module "cron_job" {
  source = "../modules/cron_job"

  cron_job_conf = [
    {
      enable = false
      region = "asia-northeast1"

      scheduler_job_conf = {
        name      = "sample"
        time_zone = "Japan"
        schedule  = "0 8 * * *"
        data      = base64encode("sample_module")
        opt_var = {
        }
      }

      pubsub_topic_conf = {
        name    = "sample"
        opt_var = {}
      }

      function_conf = {
        name = "sample"
        url = join("/", [
          "https://source.developers.google.com/projects",
          terraform.workspace,
          "repos/sample-cron-job/moveable-aliases/master/paths/src",
        ])
        runtime     = "go111"
        entry_point = ""
        opt_var     = {}
      }

    }
  ]
}
