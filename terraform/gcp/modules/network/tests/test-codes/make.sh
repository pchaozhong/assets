#!/bin/sh

PJID=$(gcloud config get-value core/project)

tee attributes.yaml <<EOF > /dev/null
gcp_project_id: '$PJID'
EOF
