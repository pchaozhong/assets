#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=source_repositories
SERVICE=sourcerepo.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,size,url" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

for csr in $(gcloud source repos list --project=$PROJECT | awk 'NR>1{print $1}') ; do
    gcloud source repos describe --project=$PROJECT --format=json $csr |\
        tee $OUTPUTDIR/json/$OUTPUT/$csr-$PROJECT.json |\
        jq -c -r '[.name, "'$PROJECT'",.size, .url] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
