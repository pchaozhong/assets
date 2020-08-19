variable "gce_conf" {
  type = list(object({
    preemptible_enable = bool
    gce_enable   = bool
    name         = string
    machine_type = string
    zone         = string
    region       = string
    tags         = list(string)
    network      = string
    access_config = object({
      nat_ip               = string
    })
    boot_disk = object({
      size        = number
      type        = string
      image       = string
      auto_delete = bool
    })
    service_account = object({
      email = string
      scopes = list(string)
    })
  }))
}

variable "scheduling" {
  type = object({
    gce_name = string
    on_host_maintenance = string
    automatic_restart = bool
  })

  default = null
}

variable "access_config" {
  type = object({
    nat_ip = string
  })

  default = {
    nat_ip = null
  }
}
