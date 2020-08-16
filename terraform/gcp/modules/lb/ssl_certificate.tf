locals {
  _mng_ssl_cert_conf = flatten([
    for _conf in var.lb_conf : [
      for _cert in _conf.mng_ssl_cert : {
        name = _cert.name
        domains = _cert.domains
      }
    ]
  ])
}

resource "google_compute_managed_ssl_certificate" "main" {
  for_each = { for v in local._mng_ssl_cert_conf : v.name => v}

  provider = "google-beta"
  name = each.value.name
  managed {
    domains = each.value.domains
  }
}
