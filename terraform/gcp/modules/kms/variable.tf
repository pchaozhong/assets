variable "key_ring" {
  type = object({
    name     = string
    location = string
  })
}

variable "keys" {
  type = list(object({
    name = string
  }))
}
/*
Option Configurations
*/

variable "project" {
  type    = string
  default = null
}

variable "algorithm" {
  type    = map(string)
  default = null
}

variable "protection_level" {
  type    = map(string)
  default = null
}
