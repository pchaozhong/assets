variable "vpc_network" {
  type = object({
    name = string
  })
}

variable "subnetworks" {
  type = list(object({
    name   = string
    cidr   = string
    region = string
  }))
}

variable "firewall" {
  type = list(object({
    name      = string
    direction = string
    tags      = list(string)
    ranges    = list(string)
    priority  = number
    rules = list(object({
      type     = string
      protocol = string
      ports    = list(string)
    }))
    log_config_metadata = string
  }))
}

/*

Option Configurations

*/

variable "project" {
  type    = string
  default = null
}

variable "vpc_network_routing" {
  type    = string
  default = "GLOBAL"
}

variable "vpc_network_mtu" {
  type    = number
  default = 1460
}

variable "vpc_network_delete_default_routes_on_create" {
  type    = bool
  default = false
}

variable "subnet_purpose" {
  type    = map(string)
  default = null
}

variable "subnet_secondary_ip_range" {
  type = map(list(object({
    range_name    = string
    ip_cidr_range = string
  })))
  default = null
}

variable "subnet_private_google_access" {
  type    = bool
  default = false
}

variable "subnet_log_config" {
  type = map(list(object({
    aggregation_interval = string
    flow_sampling        = number
    metadata             = string
    metadata_fields      = list(string)
    filter_expr          = string
  })))
  default = null
}

variable "fw_disabled" {
  type    = bool
  default = null
}
