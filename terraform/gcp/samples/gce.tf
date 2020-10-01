module "gce" {
  depends_on = [
    module.network,
    module.iam,
    module.service_account
  ]
  source = "../modules/gce"

  gce_conf = [
    {
      gce_enable = false

      name         = "test"
      machine_type = "f1-micro"
      zone         = local.zone
      region       = local.region
      tags         = ["test"]
      subnetwork   = local.subnetwork.name
      opt_conf = {
        access_config = true
        preemptible   = true
      }
      service_account = {
        email  = "test-module"
        scopes = []
      }
      boot_disk = {
        size     = 10
        type     = "pd-ssd"
        opt_conf = {
          image    = "ubuntu-2004-lts"
        }
      }
    }
  ]
}

