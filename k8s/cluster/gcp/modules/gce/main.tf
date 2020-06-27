resource "google_compute_instance" "main" {
  for_each = { for conf in var.gce_confs : conf["name"] => conf if var.gce_enabled }

  name         = each.value["name"]
  machine_type = each.value["machine_type"]
  zone         = each.value["zone"]

  tags = each.value["tags"]

  network_interface {
    subnetwork = each.value["subnetwork"]
    dynamic "access_config" {
      for_each = { for conf in each.value["access_config"] : conf["conf"] => conf if each.value["access_config_enabled"] }

      content {
        nat_ip = access_config.value["nat_ip"]
      }
    }
  }

  boot_disk {
    auto_delete = each.value["boot_disk_auto_delete"]
    device_name = each.value["boot_disk_device_name"]
    source      = google_compute_disk.boot_disk[each.value["name"]].self_link
  }

  dynamic "scheduling" {
    for_each = { for conf in each.value["scheduling_conf"] : conf["scheduling"] => conf if each.value["scheduling_conf_enabled"] }
    content {
      preemptible       = scheduling.value["preemptible"]
      automatic_restart = scheduling.value["automatic_restart"]
    }
  }

}

resource "google_compute_disk" "boot_disk" {
  for_each = { for conf in var.gce_confs : conf["name"] => conf if var.gce_enabled }

  name  = "${each.value["name"]}-boot-disk"
  type  = each.value["boot_disk_type"]
  zone  = each.value["zone"]
  image = each.value["boot_disk_img"]
  size  = each.value["boot_disk_size"]
}
