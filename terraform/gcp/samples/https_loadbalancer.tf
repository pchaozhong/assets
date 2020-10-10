locals {
  https_lb = {
    enable      = true
    name        = "https-lb-demo"
    subnet_cidr = "192.168.10.0/24"
    region      = "asia-northeast1"
    zone        = "asia-northeast1-b"
    target_size = 1
  }
}

module "https_loadbalancer" {
  depends_on = [
    module.https_lb_nw,
    module.https_lb_sa
  ]

  source = "../modules/https_loadbalancer"

  https_loadbalancer_conf = {
    enable = local.https_lb.enable

    instance_template_conf = [
      {
        enable = local.https_lb.enable

        name_prefix  = local.https_lb.name
        machine_type = "f1-micro"
        subnetwork   = local.https_lb.name
        email        = local.https_lb.name
        region       = local.https_lb.region
        disk_size_gb = 20
        source_image = "debian-cloud/debian-9"
        scopes = [
          "https://www.googleapis.com/auth/cloud-platform"
        ]
        opt_conf = {}
      }
    ]

    instance_group_manager_conf = [
      {
        enable             = local.https_lb.enable
        name               = local.https_lb.name
        base_instance_name = local.https_lb.name
        zone               = local.https_lb.zone
        target_size        = local.https_lb.target_size
        description        = "https module test"
        version = [
          {
            name              = local.https_lb.name
            instance_template = local.https_lb.name

            target_size = {
              enable         = false
              fixed_enable   = false
              percent_enable = false

              fixed   = null
              percent = null
            }
          }
        ]
        opt_conf = {}
      }
    ]

    health_check_conf = [
      {
        enable = true

        name                = local.https_lb.name
        healthy_threshold   = 2
        timeout_sec         = 5
        check_interval_sec  = 10
        unhealthy_threshold = 3

        http_health_check = {
          enable       = true
          port_name    = local.https_lb.name
          host         = null
          request_path = "/"
        }
      }
    ]

    backend_service_conf = [
      {
        enable = true

        name          = local.https_lb.name
        protocol      = "HTTP"
        health_check  = local.https_lb.name
        backend       = local.https_lb.name
        instnce_group = local.https_lb.name
      }
    ]

    url_map_conf = [
      {
        enable = true

        name            = local.https_lb.name
        backend_service = local.https_lb.name
      }
    ]

    target_http_proxy_conf = [
      {
        enable = true

        name    = local.https_lb.name
        url_map = local.https_lb.name
      }
    ]

    global_forwarding_rule_conf = [
      {
        enable = true

        name       = local.https_lb.name
        target     = local.https_lb.name
        port_range = "80"
      }
    ]
  }
}

module "https_lb_nw" {
  source = "../modules/network"

  network_conf = [
    {
      vpc_network_enable      = local.https_lb.enable
      subnetwork_enable       = true
      firewall_ingress_enable = true
      firewall_egress_enable  = true
      route_enable            = true

      vpc_network_conf = {
        name     = local.https_lb.name
        opt_conf = {}
      }
      subnetwork = [
        {
          name        = local.https_lb.name
          cidr        = local.https_lb.subnet_cidr
          description = "test"
          region      = local.https_lb.region
          opt_conf = {
          }
        }
      ]
      firewall_ingress_conf = []
      firewall_egress_conf  = []
      route_conf            = []
    }
  ]
}

module "https_lb_sa" {
  source = "../modules/service_account"

  service_account_conf = [
    {
      enable = local.https_lb.enable

      account_id = local.https_lb.name
    }
  ]
}
