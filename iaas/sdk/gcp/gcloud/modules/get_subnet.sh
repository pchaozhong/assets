#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=subnet
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

declare -a subnets=($(gcloud compute networks subnets list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a regions=($(gcloud compute networks subnets list --project $PROJECT | awk 'NR>1{print $2}'))

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,network,region,privateIpGoogleAccess,purpose,gatewayAddress" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

count=0
while [ $count -lt ${#subnets[@]} ]; do
    gcloud compute networks subnets describe --format json --region ${regions[$count]} --project $PROJECT  ${subnets[$count]} | \
        tee $OUTPUTDIR/json/$OUTPUT/${subnets[$count]}-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.network,.region,.privateIpGoogleAccess,.purpose,.gatewayAddress] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done
