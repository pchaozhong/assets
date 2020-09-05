locals {
  code_repo = "asset"
  code_file_path = "iaas/sdk/gcp/golang/functions/helloworld/"
}

module "gcf" {
  source = "../modules/glue"

  glue_conf = [
    {
      enable = false

      gcf_conf = {
        name                  = "HelloWorld"
        runtime               = "go113"
        region                = "asia-northeast1"
        environment_variables = {}

        opt_var = {
          event_trigger     = true
          source_repository = true

          entry_point = "HelloPubSub"
          resource_type = "pubsub"
          resource      = "module-test"
          url = join("/", [
            "https://source.developers.google.com/projects",
            terraform.workspace,
            "repos",
            local.code_repo,
            "moveable-aliases/master/paths/",
            local.code_file_path
          ])
        }
      }

      pubsub_conf = [
        {
          enable = true

          name     = "module-test"
          opt_conf = {}
        }
      ]
      gcs_conf = []
    }
  ]
}
