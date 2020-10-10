#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=vpc-network
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

echo "autoCreateSubnetworks,name,x_gcloud_bgp_routing_mode,x_gcloud_subnet_mode" > $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
NETWORKS=$(gcloud compute networks list --project=$PROJECT | awk 'NR>1{print $1}')
for nw in ${NETWORKS[@]}; do
    gcloud compute networks describe $nw --format=json --project=$PROJECT |\
        tee $OUTPUTDIR/json/$OUTPUT/$nw-$PROJECT.json | \
        jq -r -c '[.autoCreateSubnetworks, .name, .x_gcloud_bgp_routing_mode, .x_gcloud_subnet_mode] | @csv'| \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
done
