resource "google_compute_network" "main" {
  count = var.vpc_enabled ? 1 : 0

  name                    = var.vpc_nw_name
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "main" {
  for_each = { for conf in var.subnet_configs : conf["name"] => conf if var.subnetwork_enabled }

  name          = each.value["name"]
  network       = google_compute_network.main[0].self_link
  ip_cidr_range = each.value["ip_range"]
  region        = each.value["region"]
}

resource "google_compute_firewall" "main" {
  for_each = { for conf in var.fw_configs : conf["name"] => conf if var.fw_enabled }

  name           = each.value["name"]
  network        = google_compute_network.main[0].self_link
  priority       = each.value["priority"]
  target_tags    = each.value["target_tags"]
  source_ranges  = each.value["source_ranges"]
  source_tags    = each.value["source_tags"]
  enable_logging = each.value["enable_logging"]

  dynamic "allow" {
    for_each = each.value["rules"]
    content {
      protocol = allow.value["protocol"]
      ports    = allow.value["ports"]
    }
  }
}
