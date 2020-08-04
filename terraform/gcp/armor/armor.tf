locals {
  armor = {
    ips = jsondecode(file("./monitoring_ip_list.json"))
  }
}

### Stack Monitoring Agent accessess aloow policy
resource "google_compute_security_policy" "main" {
  name = "stackdriver-access-policy"
  dynamic "rule" {
    for_each = toset(local.armor.ips)
    content {
      action   = "allow"
      priority = 1000 + index(local.armor.ips, rule.value)
      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = [rule.value.ipAddress]
        }
      }
    }
  }

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"
  }

}
