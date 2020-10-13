#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=health_check
CSVHEADER="name,project,type,unhealthyThreshold,portName,proxyHeader,requestPath,timeoutSec,checkIntervalSec"
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
make_header $CSVHEADER $OUTPUTDIR $OUTPUT

health_checks=$(gcloud compute health-checks list --project $PROJECT | awk 'NR>1{print $1}')


for hc in ${health_checks[@]}; do
    gcloud compute health-checks describe --project $PROJECT --format json $hc |\
        tee $OUTPUTDIR/json/$OUTPUT/$hc-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.type,.unhealthyThreshold,.httpHealthCheck.portName,.httpHealthCheck.proxyHeader,.httpHealthCheck.requestPath,.timeoutSec,.checkIntervalSec]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
