#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=container_registory
CSVHEADER="name,project,registry,repository"

SERVICES=(
    containerregistry.googleapis.com
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

containers=$(gcloud container images list --project $PROJECT | awk 'NR>1{print $1}')

for container in ${containers[@]}; do
    tmp=$(echo $container | tr '/' ' ')
    declare -a tmparray=($tmp)
    filename=${tmparray[$((${#tmparray[@]} - 1))]}

    gcloud container images describe --project $PROJECT --format json $container |\
        tee $OUTPUTDIR/json/$OUTPUT/$filename-$PROJECT.json |\
        jq -r -c '["'$filename'","'$PROJECT'",.image_summary.registry,.image_summary.repository]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
