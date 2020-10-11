#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=route
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,destRange,network,priority" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

for route in $(gcloud compute routes list --project $PROJECT | awk 'NR>1{print $1}'); do
    gcloud compute routes describe --project $PROJECT --format=json $route | \
        tee $OUTPUTDIR/json/route/$route-$PROJECT.json | jq -r '[.name,"'$PROJECT'",.destRange,.network,.priority]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done

