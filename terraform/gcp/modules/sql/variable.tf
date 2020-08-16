variable "sql_conf" {
  type = list(object({
    database_instance_name = string

    db_conf = list(object({
      name = string
    }))

    db_instance_conf = list(object({
      db_version = string
      settings = object({
        tier              = string
        disk_type         = string
        availability_type = string
      })
    }))
  }))
}
