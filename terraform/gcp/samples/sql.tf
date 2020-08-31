module "sql" {
  source = "../modules/sql"

  sql_conf = [
    # {
    #   database_instance_name = "demo-psgre-proxy"

    #   db_conf = [
    #     {
    #       name = "test-db"
    #     }
    #   ]

    #   db_instance_conf = [
    #     {
    #       db_version = "POSTGRES_11"
    #       settings = {
    #         tier              = "db-f1-micro"
    #         availability_type = "ZONAL"
    #         disk_type         = "PD_HDD"
    #       }
    #     }
    #   ]
    # }
  ]
}
