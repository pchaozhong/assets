resource "google_sql_database_instance" "main" {
  for_each = { for v in var.db_instance_conf : v.name => v }

  name             = each.value.name
  database_version = each.value.db_version

  dynamic "settings" {
    for_each = each.value.setting
    content {
      tier              = settings.value.tier
      availability_type = settings.value.availability_type
      disk_type         = settings.value.disk_type
    }
  }
}

resource "google_sql_database" "main" {
  for_each = { for v in var.sql_conf : v.name => v }

  name          = each.value.name
  instance = google_sql_database_instance.main[each.value.instance_name].name
}
