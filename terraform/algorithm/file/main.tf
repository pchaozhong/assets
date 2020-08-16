locals {
  ips_map = jsondecode(file("./monitoring_ip_list.json"))

  _ips_list = chunklist(flatten([
    for v in local.ips_map : v.ipAddress
  ]),10)

  ids = [
    for v in local._ips_list : index(local._ips_list,v)
  ]

  _req_list = flatten([
    for _ele in local._ips_list : {
      ips = _ele
      type = var.files_rule.type
      priority = 1000 + index(local._ips_list,_ele)
    }
  ])
}

variable "files_rule" {
  type = object({
    type = string
  })
  default = {
    type = "allow"
    versioned_expr = "SRC_IPS_V1"
  }
}

output "file" {
  value = local._req_list
}
