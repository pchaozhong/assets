#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=monitoring_alert
SERVICE=cloudmonitoring.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

alertlists=$(gcloud alpha monitoring policies list --project $PROJECT | jq -r -c '.[] | .name')

for alert in ${alertlists[@]}; do
    tmp=$(echo $alert | tr '/' ' ')
    declare -a tmparray=($tmp)
    filename=${tmparray[$((${#tmparray[@]} - 1))]}

    gcloud alpha monitoring policies describe --project $PROJECT --format json $alert > $OUTPUTDIR/json/$OUTPUT/$filename-$PROJECT.json
done
