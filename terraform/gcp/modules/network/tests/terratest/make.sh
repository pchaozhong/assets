#!/bin/sh

PJ=$1
FILEPATH=$2
TERRAFORMVERSION=$3

tee $FILEPATH <<EOF
terraform {
  required_version = "~> $TERRAFORMVERSION"
}

provider "google" {
  project = "$PJ"
}

provider "google-beta" {
  project = "$PJ"
}
EOF
