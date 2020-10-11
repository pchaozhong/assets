#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=health_check
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

health_checks=$(gcloud compute health-checks list --project $PROJECT | awk 'NR>1{print $1}')

if [ -z health_checks ]; then
    exit 0
fi

echo "name,type,unhealthyThreshold,portName,proxyHeader,requestPath,timeoutSec,checkIntervalSec" > $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
for hc in ${health_checks[@]}; do
    gcloud compute health-checks describe --project $PROJECT --format json $hc |\
        tee $OUTPUTDIR/json/$OUTPUT/$hc-$PROJECT.json |\
        jq -r -c '[.name,.type,.unhealthyThreshold,.httpHealthCheck.portName,.httpHealthCheck.proxyHeader,.httpHealthCheck.requestPath,.timeoutSec,.checkIntervalSec]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
done
