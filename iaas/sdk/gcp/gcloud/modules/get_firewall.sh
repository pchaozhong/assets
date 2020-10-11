#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=firewall
SERVICE=compute.googleapis.com

echo "get firewall"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

for fw in $(gcloud compute firewall-rules list --project $PROJECT | awk 'NR>1{print $1}') ; do
    gcloud compute firewall-rules describe --format=json --project $PROJECT $fw > $OUTPUTDIR/json/firewall/$fw-$PROJECT.json
done
