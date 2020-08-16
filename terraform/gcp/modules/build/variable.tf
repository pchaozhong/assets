variable "build_conf" {
  type = list(object({
    build_enable = bool

    name           = string
    disabled       = bool

    filename       = string
    ignored_files  = list(string)
    included_files = list(string)
    substitutions = map(string)

    trigger_template = list(object({
      repo_name   = string
      branch_name = string
      tag_name    = string
      commit_sha  = string
    }))

    github = list(object({
      owner = string
      name  = string
      pull_request = list(object({
        branch          = string
        comment_control = string
        invert_regex    = string
      }))
      push = list(object({
        invert_regex = string
        branch       = string
        tag          = string
      }))
    }))

    build = list(object({
      tags    = list(string)
      images  = list(string)
      timeout = number
      step = object({
        name       = string
        args       = list(string)
        env        = string
        id         = string
        entrypoint = string
        dir        = string
        secret_env = string
        timeout    = number
        timing     = string
      })
    }))
  }))
}
