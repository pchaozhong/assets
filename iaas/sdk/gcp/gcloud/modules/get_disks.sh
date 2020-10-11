#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=gce_disk
SERVICE=compute.googleapis.com

echo "get gce disk"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

declare -a disks=($(gcloud compute disks list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a zones=($(gcloud compute disks list --project $PROJECT | awk 'NR>1{print $2}'))

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,zone,size,sourceImage" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

count=0
while [ $count -lt ${#disks[@]} ]; do
    gcloud compute disks describe --format json --zone ${zones[$count]} --project $PROJECT ${disks[$count]}  | \
        tee -a $OUTPUTDIR/json/gce_disk/${disks[$count]}-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.zone,.sizeGb,.sourceImage] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done

