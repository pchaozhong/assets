variable "gce_conf" {
  type = list(object({
    gce_enable   = bool
    name         = string
    machine_type = string
    zone         = string
    region       = string
    tags         = list(string)
    subnetwork   = string
    boot_disk = object({
      size     = number
      type     = string
      opt_conf = map(string)
    })
    service_account = object({
      email  = string
      scopes = list(string)
    })
    opt_conf = map(string)
  }))
}
