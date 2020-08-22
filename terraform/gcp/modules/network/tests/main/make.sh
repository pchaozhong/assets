#!/bin/sh

PJ=$1
PREFIX=$2

tee terraform.tf <<EOF > /dev/null
terraform {
    required_version = "~> 0.13"
    backend "gcs" {
        bucket = "$PJ-terraform-modules-state"
        prefix = "$PREFIX"
    }
}

provider "google" {
    project = terraform.workspace
}

provider "google-beta" {
    project = terraform.workspace
}
EOF
