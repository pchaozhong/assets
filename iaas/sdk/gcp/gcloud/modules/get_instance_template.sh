#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=instance_template
SERVICE=compute.googleapis.com

echo "get instance template"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

instance_templates_list=$(gcloud compute instance-templates list --project $PROJECT | awk 'NR>1{print $1}')

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,machinetype" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

for it in ${instance_templates_list[@]}; do
    gcloud compute instance-templates describe --project $PROJECT --format json $it |\
        tee $OUTPUTDIR/json/$OUTPUT/$it-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.properties.machineType]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
