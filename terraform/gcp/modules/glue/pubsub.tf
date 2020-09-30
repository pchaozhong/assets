locals {
  _pubsub_conf = distinct(flatten([
    for _conf in var.glue_conf : [
      for _p_conf in _conf.pubsub_conf : _p_conf if _p_conf.enable
    ] if _conf.enable
  ]))
}

resource "google_pubsub_topic" "main" {
  for_each = { for v in local._pubsub_conf : v.name => v }

  name = each.value.name
}
