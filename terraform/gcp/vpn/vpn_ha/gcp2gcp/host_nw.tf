resource "google_compute_network" "demohost" {
  name                    = "vpn-host"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "demohost" {
  name          = "vpn-host"
  ip_cidr_range = "192.168.0.0/24"
  region        = "asia-northeast1"
  network       = google_compute_network.demohost.name
}

resource "google_compute_ha_vpn_gateway" "host_ha_gw" {
  provider = google-beta
  region   = "asia-northeast1"
  name     = "host-ha-vpn1"
  network  = google_compute_network.demohost.self_link
}

resource "google_compute_router" "hostrouter" {
  provider = google-beta
  name     = "host-router"
  network  = google_compute_network.demohost.name
  bgp {
    asn = 64516
  }
}

resource "google_compute_vpn_tunnel" "host-tunnel1" {
  provider              = google-beta
  name                  = "host-ha-vpn-tunnel1"
  region                = "asia-northeast1"
  vpn_gateway           = google_compute_ha_vpn_gateway.host_ha_gw.self_link
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.guest_ha_gw.self_link
  shared_secret         = "LnXOSA7mG5ukKkAitxVtA8eoEVUqporU"
  router                = google_compute_router.hostrouter.self_link
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "host-tunnel2" {
  provider              = google-beta
  name                  = "host-ha-vpn-tunnel2"
  region                = "asia-northeast1"
  vpn_gateway           = google_compute_ha_vpn_gateway.host_ha_gw.self_link
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.guest_ha_gw.self_link
  shared_secret         = "c76d6RFOG0uxozgtcGXglUJ8GsEh8OYO"
  router                = google_compute_router.hostrouter.self_link
  vpn_gateway_interface = 1
}

resource "google_compute_router_interface" "host-router-if1" {
  provider   = google-beta
  name       = "hostrouter-if1"
  router     = google_compute_router.hostrouter.name
  region     = "asia-northeast1"
  ip_range   = "169.254.0.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.host-tunnel1.name
}

resource "google_compute_router_peer" "hostrouter_peer1" {
  provider                  = google-beta
  name                      = "hostrouter-peer1"
  router                    = google_compute_router.hostrouter.name
  region                    = "asia-northeast1"
  peer_ip_address           = "169.254.0.1"
  peer_asn                  = 64515
  advertised_route_priority = 2000
  interface                 = google_compute_router_interface.host-router-if1.name
}

resource "google_compute_router_interface" "host-router-if2" {
  provider   = google-beta
  name       = "hostrouter-if2"
  router     = google_compute_router.hostrouter.name
  region     = "asia-northeast1"
  ip_range   = "169.254.1.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.host-tunnel2.name
}

resource "google_compute_router_peer" "hostrouter_peer2" {
  provider                  = google-beta
  name                      = "hostrouter-peer2"
  router                    = google_compute_router.hostrouter.name
  region                    = "asia-northeast1"
  peer_ip_address           = "169.254.1.1"
  peer_asn                  = 64515
  advertised_route_priority = 2001
  interface                 = google_compute_router_interface.host-router-if2.name
}

