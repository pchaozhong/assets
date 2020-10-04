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
  })
}
