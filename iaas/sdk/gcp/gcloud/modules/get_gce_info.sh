#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=gce
SERVICE=compute.googleapis.com

echo "get gce"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

declare -a gces=($(gcloud compute instances list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a zones=($(gcloud compute instances list --project $PROJECT | awk 'NR>1{print $2}'))

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,zone" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

count=0
while [ $count -lt ${#gces[@]} ]; do
    gcloud compute instances describe --format json --zone ${zones[$count]} --project $PROJECT ${gces[$count]} | \
        tee -a $OUTPUTDIR/json/$OUTPUT/${gces[$count]}-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.zone] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done
