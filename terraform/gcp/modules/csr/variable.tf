variable "csr_conf" {
  type = list(object({
    csr_enable = bool
    name       = string

    opt_conf = map(string)
  }))
}
