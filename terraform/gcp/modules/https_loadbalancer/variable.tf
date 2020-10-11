variable "https_loadbalancer_conf" {
  type = object({
    enable = bool

    instance_template_conf = list(object({
      enable       = bool
      name_prefix  = string
      machine_type = string
      subnetwork   = string
      region       = string
      email        = string
      disk_size_gb = number
      source_image = string
      scopes       = list(string)
      opt_conf     = map(string)
    }))

    instance_group_manager_conf = list(object({
      enable             = bool
      name               = string
      base_instance_name = string
      zone               = string
      target_size        = number
      description        = string
      version = list(object({
        name              = string
        instance_template = string

        target_size = object({
          enable         = bool
          fixed_enable   = bool
          percent_enable = bool
          fixed          = number
          percent        = number
        })

      }))
      opt_conf = map(string)
    }))

    health_check_conf = list(object({
      enable              = bool
      name                = string
      healthy_threshold   = number
      timeout_sec         = number
      check_interval_sec  = number
      unhealthy_threshold = number

      http_health_check = object({
        enable       = bool
        port_name    = string
        host         = string
        request_path = string
      })
    }))

    backend_service_conf = list(object({
      enable        = bool
      name          = string
      protocol      = string
      health_check  = string
      backend       = string
      instnce_group = string
    }))

    url_map_conf = list(object({
      enable          = bool
      name            = string
      backend_service = string
    }))

    target_http_proxy_conf = list(object({
      enable  = bool
      name    = string
      url_map = string
    }))

    global_forwarding_rule_conf = list(object({
      enable     = bool
      name       = string
      target     = string
      port_range = string
    }))
  })
}
