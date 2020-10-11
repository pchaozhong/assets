#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=http_health_check
SERVICE=compute.googleapis.com

echo "get http health check"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

http_health_checks=$(gcloud compute http-health-checks list --project $PROJECT | awk 'NR>1{print $1}')

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,port,requestPath,timeoutSec,unhealthyTreshold,healthyThreshold,checkIntervalSec" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

for hhc in ${http_health_checks[@]}; do
    gcloud compute http-health-checks describe --project $PROJECT --format json $hhc |\
        tee $OUTPUTDIR/json/$OUTPUT/$hhc-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.port,.requestPath,.timeoutSec,.unhealthyTreshold,.healthyThreshold,.checkIntervalSec]|@csv' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
