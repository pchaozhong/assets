variable "key_ring" {
  type = list(object({
    name     = string
    location = string
  }))
}

variable "crypto_key" {
  type = list(object({
    name            = string
    key_ring        = string
    prevent_destroy = bool
  }))
}

resource "google_kms_key_ring" "main" {
  depends_on = [google_project_service.main]

  for_each = { for v in var.key_ring : v.name => v }

  name     = each.value.name
  location = each.value.location
}

resource "google_kms_crypto_key" "main" {
  for_each = { for v in var.crypto_key : v.name => v }

  name     = each.value.name
  key_ring = google_kms_key_ring.main[each.value.key_ring].self_link
  lifecycle {
    prevent_destroy = each.value.prevent_destroy
  }
}
