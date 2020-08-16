module "build" {
  source = "../modules/build"

  build_conf = [
    {
      name = "module-test"
      disabled = true
      filename = "cloudbuild.yaml"
      ignored_files = null
      included_files = null
      substitutions = {
        _FOO = "bar"
      }

      trigger_template = [
        {
          repo_name = "my-repo"
          branch_name = "master"
          tag_name = null
          commit_sha = null
        }
      ]

      github = []
      build = []
    }
  ]
}
