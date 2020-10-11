#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=ssl_certificate
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

ssls=$(gcloud compute ssl-certificates list --project $PROJECT | awk 'NR>1{print $1}')

if [ -z $ssls ] ; then
    exit 0
fi

echo "name,type,subjectAlternativeNames" > $OUTPUTDIR/csv/$OUTPUT/$ssl-$PROJECT.csv

for ssl in ${ssls[@]}; do
    gcloud compute ssl-certificates describe --project $PROJECT --format jobs $ssl |\
        tee $OUTPUTDIR/json/$OUTPUT/$ssl-$PROJECT.json |\
        jq -r -c '[.name,.type,.subjectAlternativeNames[]]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT/$ssl-$PROJECT.csv
done
