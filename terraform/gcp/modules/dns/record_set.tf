locals {
  _record_set_conf = flatten([
    for _conf in var.dns_conf : [
      for _record in _conf.record_set : {
        id           = _record.id
        name         = _record.name
        type         = _record.type
        ttl          = _record.ttl
        managed_zone = _conf.zone_name
        rrdatas      = _record.rrdatas
      }
    ]
  ])
}

resource "google_dns_record_set" "main" {
  for_each = { for v in local._record_set_conf : v.id => v }

  name         = each.value.name
  type         = each.value.type
  ttl          = each.value.ttl
  managed_zone = google_dns_managed_zone.main[each.value.managed_zone].name
  rrdatas      = each.value.rrdatas
}
