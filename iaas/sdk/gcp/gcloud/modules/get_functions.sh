#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=functions
SERVICE=cloudfunctions.googleapis.com

echo "get function"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

declare -a functions=($(gcloud functions list --project=$PROJECT |awk 'NR>1{print $1}'))
declare -a regions=($(gcloud functions list --project=$PROJECT|awk 'NR>1{print $5}'))

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,availableMemoryMb,runtime,timeout,entryPoint,eventType,resource,service,ingressSettings,serviceAccountEmail,sourceRepository,url,status" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

count=0
while [ $count -lt ${#functions[@]} ]; do
    gcloud functions describe --region ${regions[$count]} --project $PROJECT --format=json ${functions[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUT/${functions[$count]}-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.entryPoint, .availableMemoryMb, .timeout, .runtime, .eventTrigger.eventType, .eventTrigger.resource]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done

