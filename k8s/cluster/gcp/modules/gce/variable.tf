variable "gce_enabled" {
  type    = bool
  default = true
}

variable "gce_confs" {
  type = list(object({
    name                  = string
    machine_type          = string
    zone                  = string
    tags                  = list(string)
    subnetwork            = string
    boot_disk_auto_delete = bool
    boot_disk_device_name = string
    boot_disk_type        = string
    boot_disk_img         = string
    boot_disk_size        = number
    access_config_enabled = bool
    access_config = list(object({
      conf   = string
      nat_ip = string
    }))
  }))
}
