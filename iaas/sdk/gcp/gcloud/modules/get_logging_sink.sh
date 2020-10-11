#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=logging_sink
SERVICE=logging.googleapis.com

echo "get logging sink"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,filter,destination" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

sinks=$(gcloud logging sinks list --project $PROJECT | awk 'NR>1{print $1}')

for sink in ${sinks[@]}; do
    gcloud logging sinks describe --project $PROJECT --format json $sink |\
        tee $OUTPUTDIR/json/$OUTPUT/$sink-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'", .filter, .destination] | @csv' | sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
