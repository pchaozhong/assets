#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=scheduler
SERVICE=cloudscheduler.googleapis.com
SERVICE2=appengine.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

grep $SERVICE2 $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

jobs=$(gcloud scheduler jobs list --project $PROJECT | awk 'NR>1{print $1}')

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,schedule,timeZone,data,topicName" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

for job in ${jobs[@]};do
    gcloud scheduler jobs describe --project $PROJECT --format=json $job |\
        tee $OUTPUTDIR/json/$OUTPUT/$job-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.schedule,.timeZone,.pubsubTarget.data,.pubsubTarget.topicName]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
