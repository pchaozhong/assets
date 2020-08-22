#!/bin/sh

PJ=$1
FILEPATH=$2

tee $FILEPATH <<EOF
terraform {
  required_version = "~> 0.13"
}

provider "google" {
  project = "$PJ"
}

provider "google-beta" {
  project = "$PJ"
}
EOF
