variable "csr_conf" {
  type = list(object({
    name = string
    pubsub_configs = list(object({
      topic                 = string
      message_format        = string
      service_account_email = string
    }))
  }))
}

resource "google_sourcerepo_repository" "main" {
  for_each = { for v in var.csr_conf : v.name => v }

  name = each.value.name
  dynamic "pubsub_configs"{
    for_each = each.value.pubsub_configs
    content {
      topic                 = pubsub_configs.value.topic
      message_format        = pubsub_configs.value.message_format
      service_account_email = pubsub_configs.value.service_account_email
    }
  }
}
