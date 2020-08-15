module "gce" {
  source = "./modules/gce"

  gce_conf = [
    {
      name             = "test"
      machine_type     = "f1-micro"
      zone             = local.zone
      tags             = ["test"]
      network          = module.network.subnetwork_self_link.test
      boot_disk = {
        size = 10
        image = "ubuntu-2004-lts"
        type = "pd-ssd"
        auto_delete = true
      }
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
