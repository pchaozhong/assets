#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=backend_service
SERVICES=(
    compute.googleapis.com
)

out_modules=(
    ./common/make_output_dir.sh \
        ./common/check_enable_service.sh
)

for module in ${out_modules[@]}; do
    source $module
done

for sv in ${SERVICES[@]}; do
    check_enable_service $sv $OUTPUTDIR $PROJECT
done

make_raw_log_dir $OUTPUTDIR $OUTPUT

gcloud compute backend-services list --format json --project $PROJECT > $OUTPUTDIR/json/$OUTPUT/$PROJECT.json
