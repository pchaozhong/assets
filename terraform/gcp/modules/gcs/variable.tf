variable "gcs_conf" {
  type = object({
    enable = bool

    storage_conf = list(object({
      enable = bool

      name               = string
      location           = string
      force_destroy      = string
      bucket_policy_only = string

      lifecycle_rule = object({
        enable = bool
        age    = string
        type   = string
      })

      object_conf = list(object({
        enable   = bool
        name     = string
        source   = string
        opt_conf = map(string)
      }))

    }))
  })
}
