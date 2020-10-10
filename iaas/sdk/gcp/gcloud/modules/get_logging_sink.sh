#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=logging_sink
SERVICE=logging.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi
echo "name,filter,destination" > $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
sinks=$(gcloud logging sinks list --project $PROJECT | awk 'NR>1{print $1}')

for sink in ${sinks[@]}; do
    gcloud logging sinks describe --project $PROJECT --format json $sink |\
        tee $OUTPUTDIR/json/$OUTPUT/$sink-$PROJECT.json |\
        jq -r -c '[.name, .filter, .destination] | @csv' | sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
done
