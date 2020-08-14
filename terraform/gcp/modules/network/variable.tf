variable "vpc_network_conf" {
  type = list(object({
    name                    = string
    auto_create_subnetworks = bool
  }))
}

variable "subnetwork_conf" {
  type = list(object({
    name        = string
    vpc_network = string
    cidr        = string
    region      = string
  }))
}
