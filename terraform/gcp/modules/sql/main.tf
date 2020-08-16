locals {
  _db_instance_conf = flatten([
    for _conf in var.sql_conf : [
      for _db_instance in _conf.db_instance_conf : {
        name             = _conf.database_instance_name
        database_version = _db_instance.db_version
        settings         = _db_instance.settings
      }
    ]
  ])

  _db_conf = flatten([
    for _conf in var.sql_conf : [
      for _db in _conf.db_conf : {
        name     = _db.name
        instance = _conf.database_instance_name
      }
    ]
  ])
}

resource "google_sql_database_instance" "main" {
  for_each = { for v in local._db_instance_conf : v.name => v }

  name             = each.value.name
  database_version = each.value.database_version

  settings {
    tier              = each.value.settings.tier
    availability_type = each.value.settings.availability_type
    disk_type         = each.value.settings.disk_type
  }
}

resource "google_sql_database" "main" {
  for_each = { for v in local._db_conf : v.name => v }

  name     = each.value.name
  instance = google_sql_database_instance.main[each.value.instance].name
}
