locals {
  dataflow = {
    enable = true

    name         = "dataflow-demo"
    region       = "asia-northeast1"
    zone         = "asia-northeast1-b"
    network      = "dataflow-demo"
    subnet_cidr  = "192.168.0.0/24"
    machine_type = "n1-standard-1"
    temp_file    = "dataflow_job_sample"
  }
}

module "dataflow" {
  depends_on = [
    module.dataflow_network,
    module.dataflow_service_account,
    module.dataflow_gcs
  ]

  source = "../modules/dataflow"

  dataflow_conf = [
    {
      enable = local.dataflow.enable

      job_conf = [
        {
          name                  = "dataflow-job-sample"
          template_gcs_path     = "gs://${terraform.workspace}-${local.dataflow.name}/${local.dataflow.temp_file}"
          temp_gcs_location     = local.dataflow.region
          network               = local.dataflow.name
          subnetwork            = local.dataflow.name
          machine_type          = local.dataflow.machine_type
          service_account_email = local.dataflow.name
          region                = local.dataflow.region
          zone                  = local.dataflow.zone
          params                = {}
          opt_conf              = {}
        }
      ]
    }
  ]
}

module "dataflow_network" {
  source = "../modules/network"

  network_conf = [
    {
      vpc_network_enable      = local.dataflow.enable
      subnetwork_enable       = true
      firewall_ingress_enable = true
      firewall_egress_enable  = true
      route_enable            = true

      vpc_network_conf = {
        name     = local.dataflow.name
        opt_conf = {}
      }
      subnetwork = [
        {
          name        = local.dataflow.name
          cidr        = local.dataflow.subnet_cidr
          description = "test"
          region      = local.dataflow.region
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

module "dataflow_service_account" {
  source = "../modules/service_account"

  service_account_conf = [
    {
      enable = local.dataflow.enable

      account_id = local.dataflow.name
    }
  ]
}

module "dataflow_gcs" {
  source = "../modules/gcs"

  gcs_conf = {
    enable = local.dataflow.enable

    storage_conf = [
      {
        enable = local.dataflow.enable

        name               = join("-", [terraform.workspace, local.dataflow.name])
        location           = local.dataflow.region
        force_destroy      = true
        bucket_policy_only = true
        lifecycle_rule = {
          enable = false
          age    = null
          type   = null
        }

        object_conf = [
          {
            enable = local.dataflow.enable

            name     = local.dataflow.temp_file
            source   = "./files/${local.dataflow.temp_file}"
            opt_conf = {}
          }
        ]
      }
    ]
  }
}
