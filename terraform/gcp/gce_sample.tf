module "gce" {
  source = "./modules/gce"

  gce_conf = [
    {
      name             = "test"
      machine_type     = "f1-micro"
      zone             = local.zone
      tags             = ["test"]
      network          = module.network.subnetwork_self_link.test
      disk_size        = 10
      disk_image       = "ubuntu-2004-lts"
      disk_type        = "pd-ssd"
      disk_auto_delete = true
      access_config = [
        { enable = true }
      ]
      scheduling = [
        {
          preemptible         = true
          on_host_maintenance = "TERMINATE"
          automatic_restart   = false
        }
      ]
    }
  ]
}
