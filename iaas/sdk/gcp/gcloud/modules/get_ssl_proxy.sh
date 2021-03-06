#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=ssl_proxy
CSVHEADER=""
MODULEPATH="./common/"

SERVICES=(
    compute.googleapis.com
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

gcloud compute target-ssl-proxies list --project $PROJECT --format json > $OUTPUTDIR/json/$OUTPUT/$OUTPUT.json
