#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=snapshot
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

declare -a snapshots=($(gcloud compute resource-policies list --project $PROJECT --format json | jq -r -c '.[]| .name'))
declare -a regions=($(gcloud compute resource-policies list --project $PROJECT --format json | jq -r -c '.[]| .region'))

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,region,maxRetentionDays,onSourceDiskDelete,daysInCycle,duration,startTime" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

count=0
while [ $count -lt ${#snapshots[@]} ]; do
    gcloud compute resource-policies describe --format json --region ${regions[$count]} --project $PROJECT ${snapshots[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUT/${snapshots[$count]}-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.region,.snapshotSchedulePolicy.retentionPolicy.maxRetentionDays,.snapshotSchedulePolicy.retentionPolicy.onSourceDiskDelete,.snapshotSchedulePolicy.schedule.dailySchedule.daysInCycle, .snapshotSchedulePolicy.schedule.dailySchedule.duration, .snapshotSchedulePolicy.schedule.dailySchedule.startTime]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv

    count=$(( $count + 1 ))
done
