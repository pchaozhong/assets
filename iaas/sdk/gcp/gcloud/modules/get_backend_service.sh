#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=backend_service
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

gcloud compute backend-services list --format json --project $PROJECT > $OUTPUTDIR/json/$OUTPUT/$PROJECT.json
