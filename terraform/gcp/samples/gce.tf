# module "gce" {
#   depends_on = [
#     module.network,
#     module.iam,
#     module.service_account
#   ]
#   source = "../modules/gce"

#   gce_conf = [
#     {
#       gce_enable = false

#       name         = "test"
#       machine_type = "f1-micro"
#       zone         = local.zone
#       region       = local.region
#       tags         = ["test"]
#       subnetwork   = local.subnetwork.name
#       opt_conf = {
#         access_config           = true
#         preemptible             = true
#         metadata_startup_script = "set_vsftpd_conf"
#       }
#       service_account = {
#         enable = true

#         email = "module-sample"
#         scopes = [
#           "https://www.googleapis.com/auth/cloud-platform"
#         ]
#       }
#       boot_disk = {
#         size = 20
#         type = "pd-ssd"
#         opt_conf = {
#           image = "test-ftp-server"
#         }
#       }
#     }
#   ]
# }

