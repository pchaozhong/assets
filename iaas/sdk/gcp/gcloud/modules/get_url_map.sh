#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=url_map
CSVHEADER="name,project,defaultService"

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

services=$(gcloud compute url-maps list --project $PROJECT | awk 'NR>1{print $1}')

for service in ${services[@]}; do
    gcloud compute url-maps describe --project $PROJECT --format json $service |\
        tee $OUTPUTDIR/json/$OUTPUT/$service-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'", .defaultService]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
