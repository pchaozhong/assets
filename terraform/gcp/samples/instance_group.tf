locals {
  instance_group_sample_enable = false

  _instance_group_sample = local.instance_group_sample_enable ? ["enable"] : []
}

module "instance_groupe_sample" {
  for_each = toset(local._instance_group_sample)
  source   = "../modules/compute/instance_group"

  single_zone = false

  group_manager = {
    base_name    = "sample"
    name         = "sample"
    target_size  = 3
    target_pools = []
    version = {
      name        = "sample"
      target_size = null
    }
  }

  instance_template = {
    name           = "sample"
    disk           = "sample"
    machine_type   = "f1-micro"
    can_ip_forward = false
    tags           = []
    subnetwork     = module.instance_group_sample_network["enable"].subnetwork_self_link["sample"]

    disk = {
      source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
      interface    = null
      mode         = null
      type         = null
      size         = 20
    }
  }

  auto_scaling_policy = {
    name            = "sample"
    min_replicas    = 1
    max_replicas    = 3
    cooldown_period = 60
    mode            = null
  }
}

module "instance_group_sample_network" {
  for_each = toset(local._instance_group_sample)
  source   = "../modules/network/vpc_network"

  project = terraform.workspace

  vpc_network = {
    name = "sample"
  }
  subnetworks = [
    {
      name   = "sample"
      cidr   = "192.168.10.0/24"
      region = "asia-northeast1"
    },
  ]

  firewall = []
}
