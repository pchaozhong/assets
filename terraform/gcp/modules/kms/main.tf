locals {
  _key_ring_conf = flatten([
    for _conf in var.kms_conf : {
      name     = _conf.key_ring_conf.name
      location = _conf.key_ring_conf.location
    } if _conf.kms_enable
  ])

  _crypto_key_conf = flatten([
    for _conf in var.kms_conf : [
      for _crypto in _conf.crypto_key : {
        name = _crypto.name
        key_ring = _conf.key_ring_conf.name
        prevent_destroy = _crypto.prevent_destroy
      }
    ] if _conf.crypto_enable
  ])
}

resource "google_kms_key_ring" "main" {
  depends_on = [google_project_service.main]
  for_each = { for v in local._key_ring_conf : v.name => v }

  name     = each.value.name
  location = each.value.location
}

resource "google_kms_crypto_key" "main" {
  for_each = { for v in local._crypto_key_conf : v.name => v }

  name     = each.value.name
  key_ring = google_kms_key_ring.main[each.value.key_ring].self_link
  # lifecycle {
  #   prevent_destroy = each.value.prevent_destroy
  # }
}
