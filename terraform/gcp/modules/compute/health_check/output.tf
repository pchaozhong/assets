output "id" {
  value = var.single_zone ? google_compute_health_check.main[var.health_check.name].id : google_compute_region_health_check.main[var.health_check.name].id
}

output "type" {
  value = var.single_zone ? google_compute_health_check.main[var.health_check.name].type : google_compute_region_health_check.main[var.health_check.name].type
}

output "self_link" {
  value = var.single_zone ? google_compute_health_check.main[var.health_check.name].self_link : google_compute_region_health_check.main[var.health_check.name].self_link
}
