#!/bin/sh

PJ=$1

tee attributes.yaml <<EOF > /dev/null
gcp_project_id: '$PJ'
EOF
