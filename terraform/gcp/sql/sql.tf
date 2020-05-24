locals {
  sql = {
    db_version = "POSTGRES_11"
    tier = "db-f1-micro"
    instance_name = "demo-psgre-proxy"
    database_name = "test-db"
  }
}

resource "google_sql_database" "database" {
  name  = local.sql.database_name
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_database_instance" "instance" {
  name = local.sql.instance_name
  database_version = local.sql.db_version

  settings {
    tier = local.sql.tier
    availability_type = "ZONAL"
    disk_type = "PD_HDD"
  }
}
