#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=firewall
MODULEPATH="./common/"

SERVICES=(
    cloudbuild.googleapis.com
)

out_modules=(
    make_output_dir.sh \
        check_enable_service.sh \
        make_output_header.sh
)

for module in ${out_modules[@]}; do
    source $MODULEPATH$module
done

for sv in ${SERVICES[@]}; do
    check_enable_service $sv $OUTPUTDIR $PROJECT
done

make_raw_log_dir $OUTPUTDIR $OUTPUT

for fw in $(gcloud compute firewall-rules list --project $PROJECT | awk 'NR>1{print $1}') ; do
    gcloud compute firewall-rules describe --format=json --project $PROJECT $fw > $OUTPUTDIR/json/firewall/$fw-$PROJECT.json
done
