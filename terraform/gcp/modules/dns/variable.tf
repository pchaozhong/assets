variable "dns_conf" {
  type = list(object({
    zone_name = string
    mng_zone = list(object({
      dns_name   = string
      visibility = string

      private_visibility_config = list(object({
        network_url = string
      }))

      forwarding_config = list(object({
        ipv4_address = string
      }))
    }))

    record_set = list(object({
      id           = string
      name         = string
      type         = string
      ttl          = number
      rrdatas      = list(string)
    }))
  }))
}
