variable "gce_conf" {
  type = list(object({
    name             = string
    machine_type     = string
    zone             = string
    tags             = list(string)
    network          = string
    access_config    = list(object({
      enable = bool
    }))
    scheduling = list(object({
      preemptible = bool
      on_host_maintenance = string
      automatic_restart = bool
    }))
    disk_size        = number
    disk_type        = string
    disk_image       = string
    disk_auto_delete = bool
  }))
}
