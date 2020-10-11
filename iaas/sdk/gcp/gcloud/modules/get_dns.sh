#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=dns_record
SERVICE=dns.googleapis.com

echo "get dns record"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,dnsName,visibility, nameServers" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

records=$(gcloud dns managed-zones list --project $PROJECT | awk 'NR>1{print $1}')
for rc in ${records[@]}; do
    gcloud dns managed-zones describe --project $PROJECT --format=json $rc |\
        tee $OUTPUTDIR/json/$OUTPUT/$$rc-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.dnsName, .visibility, .nameServers[] ] |@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
