module "gce" {
  source = "../modules/gce"

  gce_conf = [
    {
      gce_enable = false

      name         = "test"
      machine_type = "f1-micro"
      zone         = local.zone
      tags         = ["test"]
      network      = module.network.subnetwork_self_link.test
      boot_disk = {
        size        = 10
        image       = "ubuntu-2004-lts"
        type        = "pd-ssd"
        auto_delete = true
      }
      access_config = [
        {
          access_config_enable = true
          nat_ip               = null
        }
      ]
      scheduling = [
        {
          scheduling_enable   = true
          preemptible         = true
          on_host_maintenance = "TERMINATE"
          automatic_restart   = false
        }
      ]
    }
  ]
}
