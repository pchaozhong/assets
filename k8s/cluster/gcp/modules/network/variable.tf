variable "vpc_enabled" {
  type    = bool
  default = true
}

variable "subnetwork_enabled" {
  type    = bool
  default = true
}

variable "fw_enabled" {
  type    = bool
  default = true
}

variable "vpc_nw_name" {
  type = string
}

variable "auto_create_subnetworks" {
  type    = bool
  default = false
}

variable "subnet_configs" {
  type = list(object({
    name     = string
    ip_range = string
    region   = string
  }))
}

variable "fw_configs" {
  type = list(object({
    name           = string
    priority       = number
    target_tags    = list(string)
    source_ranges  = list(string)
    source_tags    = list(string)
    enable_logging = bool
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
  }))
}
