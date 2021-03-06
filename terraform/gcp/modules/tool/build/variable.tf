variable "trigger" {
  type = object({
    name          = string
    filename      = string
    substitutions = map(string)
  })
}

variable "trigger_template" {
  type = object({
    dir          = string
    branch_name  = string
    tag_name     = string
    commit_sha   = string
    invert_regex = string
  })
}

variable "github" {
  type = object({
    owner = string
    name  = string
    push = object({
      invert_regex = string
      branch       = string
      tag          = string
    })
  })
  default = null
}

variable "github_pr" {
  type = object({
    branch          = string
    comment_control = string
    invert_regex    = string
  })
  default = null
}

variable "ignored_files" {
  type    = list(string)
  default = []
}

variable "included_files" {
  type    = list(string)
  default = []
}

variable "repo_name" {
  type    = string
  default = null
}

variable "project" {
  type    = string
  default = null
}
