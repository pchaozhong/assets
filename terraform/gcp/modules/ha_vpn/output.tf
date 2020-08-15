output "ha_vpn_gateway_self_link" {
  value = length(var.ha_vpn_conf) != 0 ? { for v in google_compute_ha_vpn_gateway.main : v.name => v.self_link} : null
}
