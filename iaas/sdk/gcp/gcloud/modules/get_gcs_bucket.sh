#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=gcs_buckets
OBJECTS=gcs_objects
SERVICE=storage-api.googleapis.com

echo "get gcs bucket"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

if [ ! -d $OUTPUTDIR/json/$OBJECTS ]; then
    mkdir $OUTPUTDIR/json/$OBJECTS
fi

# bkts=$(gsutil ls -p $PROJECT)
# echo "name" > $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
# for bk in ${bkts[@]}; do
#     echo $bk  | tr -d 'gs://' >> $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
#     gsutil ls -L -b $bk > $OUTPUTDIR/json/gcs/$bk-$PROJECT.txt
# done
