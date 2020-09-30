variable "secret" {
  type = list(object({
    crypto_key = string
    ciphertext = string
    key_ring   = string
    location   = string
  }))
}

data "google_kms_key_ring" "main" {
  for_each = { for v in var.secret : v.key_ring => v }
  name     = each.value.key_ring
  location = each.value.location
}

data "google_kms_crypto_key" "main" {
  for_each = { for v in var.secret : v.crypto_key => v }
  name     = each.value.crypto_key
  key_ring = data.google_kms_key_ring.main[each.value.key_ring].self_link
}

data "google_kms_secret" "main" {
  for_each = { for v in var.secret : v.crypto_key => v }

  crypto_key = data.google_kms_crypto_key.main[each.value.crypto_key].self_link
  ciphertext = each.value.ciphertext
}
