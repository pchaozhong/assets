resource "google_compute_network" "demoguest" {
  name                    = "vpn-guest"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "demoguest" {
  name          = "vpn-guest"
  ip_cidr_range = "192.168.10.0/24"
  region        = "asia-northeast1"
  network       = google_compute_network.demoguest.name
}

resource "google_compute_ha_vpn_gateway" "guest_ha_gw" {
  provider = google-beta
  region   = "asia-northeast1"
  name     = "guest-ha-vpn1"
  network  = google_compute_network.demoguest.self_link
}

resource "google_compute_router" "guestrouter" {
  provider = google-beta
  name     = "guest-router"
  network  = google_compute_network.demoguest.name
  bgp {
    asn = 64515
  }
}

resource "google_compute_vpn_tunnel" "guest-tunnel1" {
  provider              = google-beta
  name                  = "guest-ha-vpn-tunnel1"
  region                = "asia-northeast1"
  vpn_gateway           = google_compute_ha_vpn_gateway.guest_ha_gw.self_link
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.host_ha_gw.self_link
  shared_secret         = "LnXOSA7mG5ukKkAitxVtA8eoEVUqporU"
  router                = google_compute_router.guestrouter.self_link
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "guest-tunnel2" {
  provider              = google-beta
  name                  = "guest-ha-vpn-tunnel2"
  region                = "asia-northeast1"
  vpn_gateway           = google_compute_ha_vpn_gateway.guest_ha_gw.self_link
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.host_ha_gw.self_link
  shared_secret         = "c76d6RFOG0uxozgtcGXglUJ8GsEh8OYO"
  router                = google_compute_router.guestrouter.self_link
  vpn_gateway_interface = 1
}

resource "google_compute_router_interface" "guest-router-if1" {
  provider   = google-beta
  name       = "guestrouter-if1"
  router     = google_compute_router.guestrouter.name
  region     = "asia-northeast1"
  ip_range   = "169.254.0.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.guest-tunnel1.name
}

resource "google_compute_router_peer" "guestrouter_peer1" {
  provider                  = google-beta
  name                      = "guestrouter-peer1"
  router                    = google_compute_router.guestrouter.name
  region                    = "asia-northeast1"
  peer_ip_address           = "169.254.0.2"
  peer_asn                  = 64516
  advertised_route_priority = 2000
  interface                 = google_compute_router_interface.guest-router-if1.name
}

resource "google_compute_router_interface" "guest-router-if2" {
  provider   = google-beta
  name       = "guestrouter-if2"
  router     = google_compute_router.guestrouter.name
  region     = "asia-northeast1"
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.guest-tunnel2.name
}

resource "google_compute_router_peer" "guestrouter_peer2" {
  provider                  = google-beta
  name                      = "guestrouter-peer2"
  router                    = google_compute_router.guestrouter.name
  region                    = "asia-northeast1"
  peer_ip_address           = "169.254.1.2"
  peer_asn                  = 64516
  advertised_route_priority = 2001
  interface                 = google_compute_router_interface.guest-router-if2.name
}
