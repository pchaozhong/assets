locals {
  _bk_service = flatten([
    for _conf in lb_conf : [
      for _bk_conf in _conf.bk_service : {
        name                   = _bk_conf.name
        health_checks          = _bk_conf.health_checks
        protocol               = _bk_conf.protocol
        timeout_sec            = _bk_conf.timeout_sec
        instance_group_manager = _conf.instance_group_manager
      }
    ]
  ])
}

resource "google_compute_backend_service" "main" {
  for_each = { for v in local._bk_service : v.name => v }

  name          = each.value.name
  health_checks = each.value.health_checks
  protocol      = each.value.protocol
  timeout_sec   = each.value.timeout_sec

  affinity_cookie_ttl_sec         = lookup(each.value.opt_var, "affinity_cookie_ttl_sec", null)
  connection_draining_timeout_sec = lookup(each.value.opt_var, "connection_draining_timeout_sec", null)
  custom_request_headers          = lookup(each.value.opt_var, "custom_request_headers", null)
  description                     = lookup(each.value.opt_var, "description", null)
  enable_cdn                      = lookup(each.value.opt_var, "enable_cdn", false)
  load_balancing_scheme           = lookup(each.value.opt_var, "load_balancing_scheme", null)
  locality_lb_policy              = lookup(each.value.opt_var, "locality_lb_policy", null)
  port_name                       = lookup(each.value.opt_var, "port_name", null)
  security_policy                 = lookup(each.value.opt_var, "security_policy", null)
  session_affinity                = lookup(each.value.opt_var, "session_affinity", null)

  project = lookup(each.value.opt_var, "", terraform.workspace)

  dynamic "iap" {
    for_each = lookup(each.value.opt_var, "iap", false) ? [{
      oauth2_client_id            = lookup(each.value.opt_var, "oauth2_client_id", null)
      oauth2_client_secret        = lookup(each.value.opt_var, "oauth2_client_secret", null)
      oauth2_client_secret_sha256 = lookup(each.value.opt_var, "oauth2_client_secret_sha256", null)
    }] : []
    content {
      oauth2_client_id            = iap.value.oauth2_client_id
      oauth2_client_secret        = iap.value.oauth2_client_secret
      oauth2_client_secret_sha256 = iap.value.oauth2_client_secret_sha256
    }
  }

  dynamic "backend" {
    for_each = lookup(each.value.opt_var, "backend", false) ? [{
      group                        = lookup(each.value.opt_var, "group", null)
      balancing_mode               = lookup(each.value.opt_var, "balancing_mode", null)
      description                  = lookup(each.value.opt_var, "description", null)
      max_connections              = lookup(each.value.opt_var, "max_connections", null)
      max_connections_per_instance = lookup(each.value.opt_var, "max_connections_per_instance", null)
      max_connections_per_endpoint = lookup(each.value.opt_var, "max_connections_per_endpoint", null)
      max_rate                     = lookup(each.value.opt_var, "max_rate", null)
      max_rate_per_instance        = lookup(each.value.opt_var, "max_rate_per_instance", null)
      max_rate_per_endpoint        = lookup(each.value.opt_var, "max_rate_per_endpoint", null)
      max_utilization              = lookup(each.value.opt_var, "max_utilization", null)
    }] : []
    content {
      group                        = google_compute_instance_group_manager.main[each.value.instance_group_manager].intance_group
      balancing_mode               = backend.value.balancing_mode
      capacity_scaler              = backend.value.capacity_scaler
      description                  = backend.value.description
      max_connections              = backend.value.max_connections
      max_connections_per_instance = backend.value.max_connections_per_instance
      max_connections_per_endpoint = backend.value.max_connections_per_endpoint
      max_rate                     = backend.value.max_rate
      max_rate_per_instance        = backend.value.max_rate_per_instance
      max_rate_per_endpoint        = backend.value.max_rate_per_endpoint
      max_utilization              = backend.value.max_utilization
    }
  }

  dynamic "circuit_breakers" {
    for_each = lookup(each.value.opt_var, "circuit_breakers", false) ? [{
      connect_timeout             = lookup(each.value.opt_var, "connect_timeout", false)
      max_requests_per_connection = lookup(each.value.opt_var, "max_requests_per_connection", null)
      max_pending_requests        = lookup(each.value.opt_var, "max_pending_requests", null)
      max_requests                = lookup(each.value.opt_var, "max_requests", null)
      max_retries                 = lookup(each.value.opt_var, "max_retries", null)
    }] : []
    content {
      dynamic "connect_timeout" {
        for_each = circuit_breakers.value.connect_timeout ? [{
          seconds = lookup(each.value.opt_var, "connect_timeout_seconds", null)
          nanos   = lookup(each.value.opt_var, "connect_nanos", null)
        }] : []
        content {
          seconds = connect_timeout.value.seconds
          nanos   = connect_timeout.value.nanos
        }
      }
      max_requests_per_connection = circuit_breakers.value.max_requests_per_connection
      max_connections             = circuit_breakers.value.max_connections
      max_pending_requests        = circuit_breakers.value.max_pending_requests
      max_requests                = circuit_breakers.value.max_requests
      max_retries                 = circuit_breakers.value.max_retries
    }
  }

  dynamic "consistent_hash" {
    for_each = lookup(each.value.opt_var, "consistent_hash", false) ? [{
      http_cookie       = lookup(each.value.opt_var, "http_cookie", false)
      http_header_name  = lookup(each.value.opt_var, "http_header_name", null)
      minimum_ring_size = lookup(each.value.opt_var, "minimum_ring_size", null)
    }] : []
    content {
      dynamic "http_cookie" {
        for_each = consistent_hash.value.http_cookie ? [{
          ttl  = lookup(each.value.opt_var, "ttl", null)
          name = lookup(each.value.opt_var, "name", null)
          path = lookup(each.value.opt_var, "path", null)
        }] : []
        content {
          dynamic "ttl" {
            for_each = http_cookie.value.ttl ? [{
              seconds = lookup(each.value.opt_var, "seconds", null)
              nanos   = lookup(each.value.opt_var, "nanos", null)
            }] : []
            content {
              seconds = ttl.value.seconds
              nanos   = ttl.value.nanos
            }
          }
          name = http_cookie.value.name
          path = http_cookie.value.path
        }
      }

      http_header_name  = consistent_hash.value.http_header_name
      minimum_ring_size = consistent_hash.value.minimum_ring_size
    }
  }

  dynamic "cdn_policy" {
    for_each = lookup(each.value.opt_var, "cdn_policy", false) ? [{
      cache_key_policy             = lookup(each.value.opt_var, "cache_key_policy", false)
      signed_url_cache_max_age_sec = lookup(each.value.opt_var, "signed_url_cache_max_age_sec", null)
    }] : []
    content {
      dynamic "cache_key_policy" {
        for_each = cdn_policy.value.cache_key_policy ? [{
          include_host                = lookup(each.value.opt_var, "include_host", null)
          include_protocol            = lookup(each.value.opt_var, "include_protocol", null)
          include_query_string        = lookup(each.value.opt_var, "include_query_string", null)
          oauth2_client_secret_sha256 = lookup(each.value.opt_var, "oauth2_client_secret_sha256", null)
        }] : []
        content {
          include_host                = cache_key_policy.value.include_host
          include_protocol            = cache_key_policy.value.include_protocol
          include_query_string        = cache_key_policy.value.include_query_string
          query_string_blacklist      = cache_key_policy.value.query_string_blacklist
          oauth2_client_secret_sha256 = cache_key_policy.value.oauth2_client_secret_sha256
        }
      }
      signed_url_cache_max_age_sec = cdn_policy.value.signed_url_cache_max_age_sec
    }
  }

  dynamic "outlier_detection" {
    for_each = lookup(each.value.opt_var, "outlier_detection", false) ? [{
      base_ejection_time = lookup(each.value.opt_var, "" , false)
      consecutive_errors = lookup(each.value.opt_var, "" , null)
      enforcing_consecutive_errors = lookup(each.value.opt_var, "" , null)
      enforcing_consecutive_gateway_failure = lookup(each.value.opt_var, "" , null)
      enforcing_success_rate = lookup(each.value.opt_var, "" , null)
      interval = lookup(each.value.opt_var, "interval", false)
      max_ejection_percent = lookup(each.value.opt_var, "max_ejection_percent", null)
      success_rate_minimum_hosts = lookup(each.value.opt_var, "success_rate_minimum_hosts", null)
      sucess_rate_request_volume = lookup(each.value.opt_var, "sucess_rate_request_volume", null)
      success_rate_stdev_factor  = lookup(each.value.opt_var, "success_rate_stdev_factor", null)
    }] : []
    content {
      dynamic "base_ejection_time" {
        for_each = outlier_detection.value.base_ejection_time ? [{
          seconds = each.value.base_ejection_time_seconds
          nanos = each.value.base_ejection_time_nanos
        }] : []
      }
      content {
        seconds = base_ejection_time.value.seconds
        nanos = base_ejection_time.value.nanos
      }

      dynamic "interval" {
        for_each = outlier_detection.value.interval ? [{
          seconds = each.value.interval_seconds
          nanos = each.value.interval_nanos
        }] : []
        content {
          seconds = interval.value.seconds
          nanos = interval.value.nanos
        }
      }
      consecutive_errors = outlier_detection.value.consecutive_errors
      enforcing_consecutive_errors = outlier_detection.value.enforcing_consecutive_errors
      enforcing_success_rate = outlier_detection.value.enforcing_success_rate
      max_ejection_percent = outlier_detection.value.max_ejection_percent
      success_rate_minimum_hosts = outlier_detection.value.success_rate_minimum_hosts
      sucess_rate_request_volume = outlier_detection.value.sucess_rate_request_volume
      success_rate_stdev_factor = outlier_detection.value.success_rate_stdev_factor
    }
  }

  dynamic "log_config" {
    for_each = lookup(each.value.opt_var, "log_config", false) ? [{
      enable = lookup(each.value.opt_var, "log_config_enable", false)
      sample_rate = lookup(each.value.opt_var, "sample_rate", null)
    }] : []
    content {
      enable = log_config.value.enable
      sample_rate = log_config.value.sample_rate
    }
  }
}
