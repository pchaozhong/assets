resource "google_compute_instance" "main" {
  for_each = { for v in var.gce_conf : v.name => v }

  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone
  tags         = each.value.tags

  boot_disk {
    auto_delete = each.value.disk_auto_delete
    source      = google_compute_disk.main[each.value.name].self_link
  }

  network_interface {
    subnetwork = each.value.network

    dynamic "access_config" {
      for_each = each.value.access_config
      content {

      }
    }
  }

  dynamic "scheduling" {
    for_each = each.value.scheduling
    content {
      preemptible         = scheduling.value.preemptible
      on_host_maintenance = scheduling.value.on_host_maintenance
      automatic_restart   = scheduling.value.automatic_restart
    }
  }
}

resource "google_compute_disk" "main" {
  for_each = { for v in var.gce_conf : v.name => v }

  name  = join("-", [each.value.name, "bootdisk"])
  size  = each.value.disk_size
  type  = each.value.disk_type
  zone  = each.value.zone
  image = each.value.disk_image
}
