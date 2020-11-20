locals {
  services = [
    "dns"
  ]

  _services = [
    for _sv in local.services : _sv if var.api_enable
  ]
}

resource "google_project_service" "googleapis" {
  count = var.api_enable ? 1 : 0

  service            = "serviceusage.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "main" {
  depends_on = [google_project_service.googleapis]
  for_each   = toset(local._services)

  service            = join(".", [each.value, "googleapis.com"])
  disable_on_destroy = false
}
