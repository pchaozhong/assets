resource "google_compute_route" "main" {
  for_each = { for v in var.route_conf : v.name => v }

  name             = each.value.name
  dest_range       = each.value.dest_range
  network          = google_compute_network.main[each.value.network].self_link
  priority         = each.value.priority
  tags             = each.value.tags
  next_hop_gateway = each.value.next_hop_gateway
}
