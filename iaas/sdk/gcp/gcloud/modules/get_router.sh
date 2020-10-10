#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUTR=cloud_router
OUTPUTN=cloud_nat
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUTR ]; then
    mkdir $OUTPUTDIR/json/$OUTPUTR
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUTN ]; then
    mkdir $OUTPUTDIR/json/$OUTPUTN
fi

routers=$(gcloud compute routers list --project $PROJECT | awk 'NR>1{print $1}')
regions=$(gcloud compute routers list --project $PROJECT | awk 'NR>1{print $2}')

echo "name,network.region" > $OUTPUTDIR/csv/$OUTPUTR-$PROJECT.csv
echo "name,natIpAllocateOption,sourceSubnetworkIpRangesToNat,logConfig.enable,logConfig.filter" > $OUTPUTDIR/csv/$OUTPUTN-$PROJECT.csv

count=0
if [ -z $routers ]; then
    exit 0
fi

while [ $count -lt ${#routers[@]} ];do
    gcloud compute routers describe --region ${regions[$count]} --format json --project $PROJECT ${routers[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUTR/${routers[$count]}-$PROJECT.json |\
        jq -r -c '[.name,.network,.region]|@csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTR-$PROJECT.csv

    nats=$(gcloud compute routers nats list --project $PROJECT --region ${regions[$count]} --router ${routers[$count]} | awk 'NR>1{print $1}')

    for nat in ${nats[@]}; do
        gcloud compute routers nats describe --project $PROJECT --region ${regions[$count]} --router ${routers[$count]} --format json $nat | \
            tee $OUTPUTDIR/json/$OUTPUTN/$nat-$PROJECT.json |\
            jq -r -c '[.name,.natIpAllocateOption,.sourceSubnetworkIpRangesToNat,.logConfig.enable,.logConfig.filter]|@csv' |\
            sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTN-$PROJECT.csv
    done
    count=$(( $count + 1 ))
done
