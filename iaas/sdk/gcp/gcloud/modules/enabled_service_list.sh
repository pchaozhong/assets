#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=service_list

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

gcloud services list --enabled --project $PROJECT | awk 'NR>1{print $1}' > $OUTPUTDIR/json/$OUTPUT/$PROJECT.txt
