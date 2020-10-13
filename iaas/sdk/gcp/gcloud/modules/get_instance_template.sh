#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=instance_template
CSVHEADER="name,project,machinetype"

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

instance_templates_list=$(gcloud compute instance-templates list --project $PROJECT | awk 'NR>1{print $1}')

for it in ${instance_templates_list[@]}; do
    gcloud compute instance-templates describe --project $PROJECT --format json $it |\
        tee $OUTPUTDIR/json/$OUTPUT/$it-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.properties.machineType]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
