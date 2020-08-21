module "build" {
  source = "../modules/build"

  build_conf = [
    {
      build_enable = true

      name = "asset-testing-network"
      disabled = true

      filename = "terraform/gcp/modules/network/tests/cloudbuild/shunit_test.yaml"

      trigger_template = [
        {
          repo_name = "github_atsushikitano_assets"
          branch_name = "master"
          tag_name = null
          commit_sha = null
        }
      ]

      github = []
      build = []
      ignored_files = null
      included_files = null
      substitutions = null
    },

  ]
}
