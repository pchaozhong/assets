variable "bq_conf" {
  type = list(object({
    enable = bool

    dataset_conf = list(object({
      dataset_id = string
      location   = string
      obt_conf   = map(string)
    }))
  }))
}
