#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=firewall
SERVICES=(
    cloudbuild.googleapis.com
)

out_modules=(
    ./common/make_output_dir.sh \
        ./common/check_enable_service.sh \
        ./common/make_output_header.sh
)

for module in ${out_modules[@]}; do
    source $module
done

for sv in ${SERVICES[@]}; do
    check_enable_service $sv $OUTPUTDIR $PROJECT
done

make_raw_log_dir $OUTPUTDIR $OUTPUT

for fw in $(gcloud compute firewall-rules list --project $PROJECT | awk 'NR>1{print $1}') ; do
    gcloud compute firewall-rules describe --format=json --project $PROJECT $fw > $OUTPUTDIR/json/firewall/$fw-$PROJECT.json
done
