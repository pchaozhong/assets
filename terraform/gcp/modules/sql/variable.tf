variable "sql_conf" {
  type = list(object({
    name          = string
    instance_name = string
  }))
}

variable "db_instance_conf" {
  type = list(object({
    name       = string
    db_version = string
    setting = list(object({
      tier              = string
      availability_type = string
      disk_type         = string
    }))
  }))
}
