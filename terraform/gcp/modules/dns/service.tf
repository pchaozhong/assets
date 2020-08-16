locals {
  services = [
    "dns"
  ]
}

resource "google_project_service" "googleapis" {
  service            = "serviceusage.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "main" {
  depends_on = [google_project_service.googleapis]
  for_each = toset(local.services)

  service            = join(".", [each.value, "googleapis.com"])
  disable_on_destroy = false
}
