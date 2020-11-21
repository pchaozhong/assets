output "id" {
  value = var.single_zone ? google_compute_health_check.main[var.health_check.name].id : null
}

output "region_id" {
  value = ! var.single_zone ? google_compute_region_health_check.main[var.health_check.name].id : null
}

output "type" {
  value = var.single_zone ? google_compute_health_check.main[var.health_check.name].type : null
}

output "region_type" {
  value = ! var.single_zone ? google_compute_region_health_check.main[var.health_check.name].type : null
}

output "self_link" {
  value = var.single_zone ? google_compute_health_check.main[var.health_check.name].self_link : null
}

output "region_self_link" {
  value = ! var.single_zone ? google_compute_region_health_check.main[var.health_check.name].self_link : null
}
