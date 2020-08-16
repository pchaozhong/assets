data "google_netblock_ip_ranges" "cloud-netblocks" {
  range_type = "cloud-netblocks"
}

data "google_netblock_ip_ranges" "google-netblock" {
  range_type = "google-netblocks"
}

data "google_netblock_ip_ranges" "restricted" {
  range_type = "restricted-googleapis"
}

data "google_netblock_ip_ranges" "private" {
  range_type = "private-googleapis"
}

data "google_netblock_ip_ranges" "dns" {
  range_type = "dns-forwarders"
}

data "google_netblock_ip_ranges" "iap" {
  range_type = "iap-forwarders"
}

data "google_netblock_ip_ranges" "hc" {
  range_type = "health-checkers"
}

data "google_netblock_ip_ranges" "legacy-hc" {
  range_type = "legacy-health-checkers"
}

output "restricted" {
  value = data.google_netblock_ip_ranges.restricted.cidr_blocks_ipv4
}
