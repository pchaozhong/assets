#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=https_health_check
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

https_health_checks=$(gcloud compute https-health-checks list --project $PROJECT | awk 'NR>1{print $1}')

echo "name,port,requestPath,timeoutSec,unhealthyTreshold,healthyThreshold,checkIntervalSec" > $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv

for hhc in ${http_health_checks[@]}; do
    gcloud compute https-health-checks describe --project $PROJECT --format json $hhc |\
        tee $OUTPUTDIR/json/$OUTPUT/$hhc-$PROJECT.json |\
        jq -r -c '[.name,.port,.requestPath,.timeoutSec,.unhealthyTreshold,.healthyThreshold,.checkIntervalSec]|@csv' >> $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
done
