module "build" {
  source = "../modules/build"

  build_conf = [
    {
      build_enable = true

      name = "network-moduletest-by-golang-sdk"
      disabled = true

      filename = "terraform/gcp/modules/network/tests/cloudbuild/golang_sdk_test.yaml"

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
    {
      build_enable = true

      name = "network-moduletest-by-terratest"
      disabled = true

      filename = "terraform/gcp/modules/network/tests/cloudbuild/terratest_test.yaml"

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
    {
      build_enable = true

      name = "network-moduletest-by-inspec"
      disabled = true

      filename = "terraform/gcp/modules/network/tests/cloudbuild/inspec_test.yaml"

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
    {
      build_enable = true

      name = "network-moduletest-by-shunit"
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

    {
      build_enable = true

      name = "network-moduletest-destroy"
      disabled = true

      filename = "terraform/gcp/modules/network/tests/cloudbuild/terraform_destroy.yaml"

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
