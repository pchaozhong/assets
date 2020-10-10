#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=gce
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

declare -a gces=($(gcloud compute instances list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a zones=($(gcloud compute instances list --project $PROJECT | awk 'NR>1{print $2}'))

echo "name,zone" > $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
count=0
while [ $count -lt ${#gces[@]} ]; do
    gcloud compute instances describe --format json --zone ${zones[$count]} --project $PROJECT ${gces[$count]} | \
        tee -a $OUTPUTDIR/json/gce/${gces[$count]}-$PROJECT.json | \
        jq -r -c '[.name,.zone] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
    count=$(( $count + 1 ))
done
