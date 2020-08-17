variable "dns_conf" {
  type = list(object({
    dns_zone_enable   = bool
    record_set_enable = bool

    zone_name = string
    mng_zone = list(object({
      dns_name   = string
      visibility = string

      private_visibility_config = list(object({
        network = string
      }))

      forwarding_config = list(object({
        ipv4_address = string
      }))
    }))

    record_set = list(object({
      id      = string
      name    = string
      type    = string
      ttl     = number
      rrdatas = list(string)
    }))
  }))
}

variable "api_enable" {
  type    = bool
  default = false
}
