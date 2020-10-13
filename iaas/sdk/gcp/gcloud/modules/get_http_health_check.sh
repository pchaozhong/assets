#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=http_health_check
SERVICE=compute.googleapis.com
SERVICES=(
    compute.googleapis.com
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
make_header "name,project,port,requestPath,timeoutSec,unhealthyTreshold,healthyThreshold,checkIntervalSec" $OUTPUTDIR $OUTPUT

http_health_checks=$(gcloud compute http-health-checks list --project $PROJECT | awk 'NR>1{print $1}')

for hhc in ${http_health_checks[@]}; do
    gcloud compute http-health-checks describe --project $PROJECT --format json $hhc |\
        tee $OUTPUTDIR/json/$OUTPUT/$hhc-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.port,.requestPath,.timeoutSec,.unhealthyTreshold,.healthyThreshold,.checkIntervalSec]|@csv' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
