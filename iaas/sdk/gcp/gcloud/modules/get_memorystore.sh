#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=memorystore
SERVICE=redis.googleapis.com

echo "get memory"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

REGIONS=$(gcloud compute regions list |awk 'NR>1{print $1}')

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,tier,memorySizeGb,redisVersion,locationId,authorizedNetwork,connectMode,port" > $OUTPUTDIR/csv/$OUTPUT.csv
fi


for region in ${REGIONS[@]}; do
    dbs=$(gcloud redis instances list --region $region |awk 'NR>1{print $1}')

    for db in ${dbs[@]}; do
        gcloud redis instances describe --region $region --format json $db |\
            tee $OUTPUTDIR/json/$OUTPUT/$db-$PROJECT.json |\
            jq -r -c '[.name,"'$PROJECT'",.tier,.memorySizeGb,.redisVersion,.locationId,.authorizedNetwork,.connectMode,.port]|@csv' |\
            sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    done
done
