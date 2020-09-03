locals {
  _topics_list = compact(distinct(flatten([
    for _conf in local._csr_conf : _conf.topic if _conf.pubsub_configs
  ])))
}

resource "google_pubsub_topic" "main" {
  for_each = toset(local._topics_list)

  name = each.value
}
