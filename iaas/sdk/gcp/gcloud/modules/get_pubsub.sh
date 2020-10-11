#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUTSUB=pubsub_subscription
OUTPUTTOP=pubsub_topics
SERVICE=pubsub.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUTSUB ]; then
    mkdir $OUTPUTDIR/json/$OUTPUTSUB
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUTTOP ]; then
    mkdir $OUTPUTDIR/json/$OUTPUTTOP
fi

subscriptions=$(gcloud pubsub subscriptions list --format=json --project=$PROJECT | jq -r -c '.[]|.name')

if [ ! -e $OUTPUTDIR/csv/$OUTPUTSUB.csv ]; then
    echo "name,project,topic,ackDeadlineSeconds,messageRetentionDuration" > $OUTPUTDIR/csv/$OUTPUTSUB.csv
fi

for sub in ${subscriptions[@]}; do
    tmp=$(echo $sub | tr '/' ' ')
    declare -a tmparray=($tmp)
    filename=${tmparray[$((${#tmparray[@]} - 1))]}

    gcloud pubsub subscriptions describe --project $PROJECT --format=json $sub |\
        tee $OUTPUTDIR/json/$OUTPUTSUB/$filename-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.topic,.ackDeadlineSeconds,.messageRetentionDuration]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTSUB.csv
done

if [ ! -e $OUTPUTDIR/csv/$OUTPUTTOP.csv ]; then
    echo "name,project" > $OUTPUTDIR/csv/$OUTPUTTOP.csv
fi

topics=$(gcloud pubsub topics list --format=json --project $PROJECT | jq -r -c '.[]|.name')

for tp in ${topics[@]};do
    gcloud pubsub topics describe --project=$PROJECT --format json $tp |\
        jq -r -c '[.name, "'$PROJECT'"]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTTOP.csv
done
