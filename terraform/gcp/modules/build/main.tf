resource "google_cloudbuild_trigger" "main" {
  for_each = { for v in var.build_conf : v.name => v }
  provider   = "google-beta"

  name           = each.value.name
  disabled       = each.value.disabled
  substitutions  = each.value.substitutions
  filename       = each.value.filename
  ignored_files  = each.value.ignored_files
  included_files = each.value.included_files

  dynamic "trigger_template" {
    for_each = each.value.trigger_template
    content {
      repo_name   = trigger_template.value.repo_name
      branch_name = trigger_template.value.branch_name
      tag_name    = trigger_template.value.tag_name
      commit_sha  = trigger_template.value.commit_sha
    }
  }

  dynamic "github" {
    for_each = each.value.github
    content {
      owner = github.value.owner
      name  = github.value.name

      dynamic "pull_request" {
        for_each = github.value.pull_request
        content {
          branch          = pull_request.value.branch
          comment_control = pull_request.value.comment_control
          invert_regex    = pull_request.value.invert_regex
        }
      }

      dynamic "push" {
        for_each = github.value.push
        content {
          invert_regex = push.value.invert_regex
          branch       = push.value.branch
          tag          = push.value.tag
        }
      }
    }
  }

  dynamic "build" {
    for_each = each.value.build
    content {
      tags    = build.value.tags
      images  = build.value.images
      timeout = build.value.timeout

      step {
        name       = build.value.step.name
        args       = build.value.step.args
        env        = build.value.step.env
        id         = build.value.step.id
        entrypoint = build.value.step.entrypoint
        dir        = build.value.step.dir
        secret_env = build.value.step.secret_env
        timeout    = build.value.step.timeout
        timing     = build.value.step.timing
      }
    }
  }


}
