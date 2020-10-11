#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=vpn_gateway
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

declare -a vpn_gws=($(gcloud compute vpn-gateways list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a regions=($(gcloud compute vpn-gateways list --project $PROJECT | awk 'NR>1{print $5}'))

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo ".name,project,network,region" > $OUTPUTDIR/csv/$OUTPUT.csv
fi


count=0
while [ $count -lt ${#vpn_gws[@]} ]; do
    gcloud compute vpn-gateways describe --format json --project $PROJECT --region ${regions[$count]} ${vpn_gws[$count]} |\
        tee -a $OUTPUTDIR/json/$OUTPUT/${vpn_gws[$count]}-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.network,.region] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done
