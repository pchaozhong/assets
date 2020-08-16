module "sql" {
  source = "../modules/sql"

  sql_conf = [
    {
      name = "test-db"
      instance_name = "demo-psgre-proxy"
    }
  ]

  db_instance_conf = [
    {
      name = "demo-psgre-proxy"
      db_version = "POSTGRES_11"
      setting = [
        {
          tier = "db-f1-micro"
          availability_type = "ZONAL"
          disk_type = "PD_HDD"
        }
      ]
    }
  ]
}
