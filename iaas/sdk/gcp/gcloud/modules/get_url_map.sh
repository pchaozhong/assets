#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=url_map
SERVICE=aaaa

SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

services=$(gcloud compute url-maps list --project $PROJECT | awk 'NR>1{print $1}')

echo "name,defaultService" > $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv

for service in ${services[@]}; do
    gcloud compute url-maps describe --project $PROJECT --format json $service |\
        tee $OUTPUTDIR/json/$OUTPUT/$service-$PROJECT.json |\
        jq -r -c '[.name, .defaultService]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
done
