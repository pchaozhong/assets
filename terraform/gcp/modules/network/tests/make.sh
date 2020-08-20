#!/bin/sh

PJ=$1

tee attributes.yaml <<EOF > /dev/null
gcp_project_id: '$PJID'
EOF

tee terraform.tf <<EOF > /dev/null
terraform {
    required_version = "~> 0.13"
    backend "gcs" {
        bucket = "$PJ-modules-state"
        prefix = "$2"
    }
}

provider "google" {
    project = terraform.workspace
}

provider "google-beta" {
    project = terraform.workspace
}
EOF
