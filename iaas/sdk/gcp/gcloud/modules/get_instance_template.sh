#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=instance_template
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

instance_templates_list=$(gcloud compute instance-templates list --project $PROJECT | awk 'NR>1{print $1}')

if [ -z $instance_templates_list ]; then
    exit 0
fi
echo "name,machinetype" > $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
for it in ${instance_templates_list[@]}; do
    gcloud compute instance-templates describe --project $PROJECT --format json $it |\
        tee $OUTPUTDIR/json/$OUTPUT/$it-$PROJECT.json |\
        jq -r -c '[.name,.properties.machineType]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
done
