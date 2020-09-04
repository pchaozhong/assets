locals {
  _gcf_conf = flatten([
    for _conf in var.glue_conf : _conf.gcf_conf if _conf.enable
  ])

  resource_type = {
    gcs_finalize        = "google.storage.object.finalize"
    gcs_delete          = "google.storage.object.delete"
    gcs_arcive          = "google.storage.object.archive"
    gcs_metadata_update = "google.storage.object.metadataUpdate"
    pubsub              = "google.pubsub.topic.publish"
  }
}

resource "google_cloudfunctions_function" "main" {
  for_each = { for v in local._gcf_conf : v.name => v }

  name                  = each.value.name
  runtime               = each.value.runtime
  environment_variables = each.value.environment_variables

  description         = lookup(each.value.opt_var, "description", null)
  available_memory_mb = lookup(each.value.opt_var, "available_memory_mb", "256MB")
  timeout             = lookup(each.value.opt_var, "timeout", 540)
  entry_point         = lookup(each.value.opt_var, "entry_point", null)

  dynamic "event_trigger" {
    for_each = lookup(each.value.opt_var, "event_trigger", false) ? [{
      event_type     = lookup(each.value.opt_var, "event_type", null)
      resource_type  = lookup(each.value.opt_var, "resource_type", null)
      resource       = lookup(each.value.opt_var, "resource", null)
      failure_policy = lookup(each.value.opt_var, "failure_policy", null)
      retry          = lookup(each.value.opt_var, "retry", false)
    }] : []
    content {
      event_type = event_trigger.value.event_type
      resource   = event_trigger.value.resource_type == "pubsub" ? google_pubsub_topic.main[event_trigger.value.resource].id : google_storage_bucket.main[event_trigger.value.resource].name
      dynamic "failure_policy" {
        for_each = event_trigger.value.failure_policy ? [{
          retry = event_trigger.value.retry
        }] : []
        content {
          retry = failure_policy.value.retry
        }
      }
    }
  }

  trigger_http                  = lookup(each.value.opt_var, "trigger_http", null)
  ingress_settings              = lookup(each.value.opt_var, "ingress_settings", null)
  service_account_email         = lookup(each.value.opt_var, "service_account_email", null) != null ? data.google_service_account.main[lookup(each.value.opt_var, "service_account_email", null)].email : null
  vpc_connector                 = lookup(each.value.opt_var, "vpc_connector", null)
  vpc_connector_egress_settings = lookup(each.value.opt_var, "vpc_connector_egress_settings", null)
  source_archive_bucket         = lookup(each.value.opt_var, "source_archive_bucket", null)
  source_archive_object         = lookup(each.value.opt_var, "source_archive_object", null)
  max_instances                 = lookup(each.value.opt_var, "max_instances", null)

  dynamic "source_repository" {
    for_each = lookup(each.value.opt_var, "source_repository", false) ? [{
      url = lookup(each.value.opt_var, "url", null)
    }] : []
    content {
      url = source_repository.value.url
    }
  }
}
