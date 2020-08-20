#!/bin/sh

PJID=$1

tee attributes.yaml <<EOF > /dev/null
gcp_project_id: '$PJID'
EOF
