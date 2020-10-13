#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=iam_binding
SERVICES=(
    iam.googleapis.com
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

gcloud projects get-iam-policy --format json $PROJECT > $OUTPUTDIR/json/$OUTPUT/$PROJECT.json
