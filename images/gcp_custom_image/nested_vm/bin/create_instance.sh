#!/bin/sh

IMAGE=nested-vm


gcloud compute instances create demo-vm --zone asia-northeast1-b \
       --min-cpu-platform "Intel Skylake" \
       --image $IMAGE
