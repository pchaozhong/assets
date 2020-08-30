variable "gcf_conf" {
  type = list(object({
    name                  = string
    runtime               = string
    gcf_enable            = bool
    environment_variables = map(string)
    opt_var               = map(string)
  }))
}
