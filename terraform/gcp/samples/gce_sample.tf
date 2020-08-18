module "gce" {
  depends_on = [ module.network ]
  source = "../modules/gce"

  gce_conf = [
    {
      preemptible_enable = true
      gce_enable = false

      name         = "test"
      machine_type = "f1-micro"
      zone         = local.zone
      region       = local.region
      tags         = ["test"]
      network      = local.subnetwork.name
      access_config = {
        nat_ip = null
      }

      boot_disk = {
        size        = 10
        image       = "ubuntu-2004-lts"
        type        = "pd-ssd"
        auto_delete = true
      }
    }
  ]
}
