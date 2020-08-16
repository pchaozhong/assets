variable "files_rule" {
  type = object({
    action         = string
    versioned_expr = string
    file_path      = string
    file_type      = string
    priority_base  = number
  })
}

variable "armor_conf" {
  type = list(object({
    name = string
    default_rule = object({
      action         = string
      priority       = number
      versioned_expr = string
      src_ip_ranges  = list(string)
    })
  }))
}
