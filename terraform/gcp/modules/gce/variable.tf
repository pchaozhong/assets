variable "gce_conf" {
  type = list(object({
    gce_enable   = bool
    name         = string
    machine_type = string
    zone         = string
    tags         = list(string)
    network      = string
    access_config = list(object({
      access_config_enable = bool
      nat_ip               = string
    }))
    scheduling = list(object({
      scheduling_enable   = bool
      preemptible         = bool
      on_host_maintenance = string
      automatic_restart   = bool
    }))
    boot_disk = object({
      size        = number
      type        = string
      image       = string
      auto_delete = bool
    })
  }))
}
