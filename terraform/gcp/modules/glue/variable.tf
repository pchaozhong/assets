variable "glue_conf" {
  type = list(object({
    enable = bool

    gcf_conf = object({
      name                  = string
      runtime               = string
      region                = string
      environment_variables = map(string)
      opt_var               = map(string)
    })

    pubsub_conf = list(object({
      enable = bool

      name     = string
      opt_conf = map(string)
    }))

    gcs_conf = list(object({
      enable = bool

      name     = string
      location = string
      opt_conf = map(string)
    }))
  }))
}
