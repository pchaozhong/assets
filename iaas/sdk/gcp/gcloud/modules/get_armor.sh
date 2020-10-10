#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=armor
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

for policies in $(gcloud compute security-policies list --project $PROJECT | awk 'NR>1{print $1}'); do
    gcloud compute security-policies describe --project $PROJECT --format=json $policies > $OUTPUTDIR/json/armor/$policies-$PROJECT.json
done
