#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=scheduler
SERVICES=(
    cloudscheduler.googleapis.com \
        appengine.googleapis.com
)
CSVHEADER="name,project,schedule,timeZone,data,topicName"

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


jobs=$(gcloud scheduler jobs list --project $PROJECT | awk 'NR>1{print $1}')

for job in ${jobs[@]};do
    gcloud scheduler jobs describe --project $PROJECT --format=json $job |\
        tee $OUTPUTDIR/json/$OUTPUT/$job-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.schedule,.timeZone,.pubsubTarget.data,.pubsubTarget.topicName]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done