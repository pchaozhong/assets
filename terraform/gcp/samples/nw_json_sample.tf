locals {
  nw_json_sample_enable = true
  nw_json_sample_config = local.nw_json_sample_enable ? jsondecode(file("./files/network_config.json")).network : []
}

output "json_config" {
  value = local.nw_json_sample_config
}
