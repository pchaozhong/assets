variable "kms_conf" {
  type = list(object({
    kms_enable    = bool
    crypto_enable = bool

    key_ring_conf = object({
      name     = string
      location = string
    })

    crypto_key = list(object({
      name            = string
      prevent_destroy = bool
    }))
  }))
}

variable "api_enable" {
  type    = bool
  default = false
}
