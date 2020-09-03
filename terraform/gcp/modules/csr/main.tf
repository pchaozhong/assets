locals {
  _csr_conf = flatten([
    for _conf in var.csr_conf : {
      name                  = _conf.name
      pubsub_configs        = lookup(_conf.opt_conf, "pubsub_configs", false)
      topic                 = lookup(_conf.opt_conf, "topic", null)
      message_format        = lookup(_conf.opt_conf, "message_format", null)
      service_account_email = lookup(_conf.opt_conf, "service_account_email", null)
    } if _conf.csr_enable
  ])
}

resource "google_sourcerepo_repository" "main" {
  for_each = { for v in local._csr_conf : v.name => v }

  name = each.value.name
  dynamic "pubsub_configs" {
    for_each = each.value.pubsub_configs ? [{
      topic                 = each.value.topic
      message_format        = each.value.message_format
      service_account_email = each.value.service_account_email
    }] : []
    content {
      topic                 = pubsub_configs.value.topic != null ? google_pubsub_topic.main[pubsub_configs.value.topic].id : null
      message_format        = pubsub_configs.value.message_format
      service_account_email = pubsub_configs.value.service_account_email
    }
  }
}
