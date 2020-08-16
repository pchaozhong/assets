module "lb" {
  source = "../modules/lb"

  lb_conf = [
    {
      instance_template      = "test"
      instance_group_manager = "test"
      https_proxy            = "test"
      url_map                = "test"
      zone                   = "asia-northeast1-b"

      bk_service = [
        {
          name          = "test"
          health_checks = []
          protocol      = string
          timeout_sec   = number
        }
      ]

      forwarding_rule = [
        {
          name       = string
          target     = string
          port_range = string
          ip_address = string
        }
      ]

      grp_mng = [
        {
          base_instance_name = string
          target_size        = 1
        }
      ]

      health_checks = [
        {
          name = "test"
          https_health_check = [
            {
              request_path = "/"
              port         = "80"
            }
          ]
          http_health_check = []
        }
      ]

      tgt_https_proxy = [
        {
          ssl_certs = [
            ""
          ]
        }
      ]

      instance_template = [
        {
          machine_type = "f1-micro"
          tags         = []
          source_image = ""
          auto_delete  = true
          subnetwork   = ""
          access_config = [
            {
              enable = true
            }
          ]
          create_before_destroy = true
        }
      ]

      mng_ssl_cert = [
        {
          name    = "test"
          domains = ""
        }
      ]

      url_map = [
        {
          default_service = ""
        }
      ]
    }
  ]
}
