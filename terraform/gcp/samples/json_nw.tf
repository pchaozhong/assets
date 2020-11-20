locals {
  json_network_sample_enable = false

  _json_network_enable = local.json_network_sample_enable ? ["enable"] : []
}

module "json_network_sample" {
  source = "../modules/file_modules/json_network"

  file_path = "./files/network_object.json"
}
