#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=iam_binding
SERVICE=iam.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

gcloud projects get-iam-policy --format json $PROJECT > $OUTPUTDIR/json/$OUTPUT/$PROJECT.json
