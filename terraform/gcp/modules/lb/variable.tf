variable "lb_conf" {
  type = list(object({
    instance_template      = string
    instance_group_manager = string
    https_proxy            = string
    url_map                = string
    zone                   = string

    bk_service = list(object({
      name          = string
      health_checks = list(string)
      protocol      = string
      timeout_sec   = number
    }))

    forwarding_rule = list(object({
      name       = string
      target     = string
      port_range = string
      ip_address = string
    }))

    grp_mng = list(object({
      base_instance_name = string
      target_size        = number
    }))

    health_check = list(object({
      name = string
      http_health_check = list(object({
        request_path = string
        port         = string
      }))
      https_health_check = list(object({
        request_path = string
        port         = string
      }))
    }))

    tgt_https_proxy = list(object({
      ssl_certs = list(string)
    }))

    instance_template = list(object({
      machine_type = string
      tags         = list(string)
      source_image = string
      auto_delete  = bool
      subnetwork   = string
      access_config = list(object({
        enable = bool
      }))
      create_before_destroy = bool
    }))

    mng_ssl_cert = list(object({
      name    = string
      domains = string
    }))

    url_map = list(object({
      default_service = string
    }))
  }))
}
