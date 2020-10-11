#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUTRING=kmsrings
OUTPUKEY=keys
LOCATION=(
    global
    asia-northeast1
)
SERVICE=cloudkms.googleapis.com

echo "get kms"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUTRING ]; then
    mkdir $OUTPUTDIR/json/$OUTPUTRING
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUKEY ]; then
    mkdir $OUTPUTDIR/json/$OUTPUKEY
fi

if [ ! -e $OUTPUTDIR/csv/$OUTPUTRING.csv ]; then
    echo "name,project,createTime" > $OUTPUTDIR/csv/$OUTPUTRING.csv
fi

if [ ! -e $OUTPUTDIR/csv/$OUTPUKEY.csv ]; then
    echo "name,project,primary.algorithm, primary.generateTime, primary.protectionLevel, primary.state, purpose, versionTemplate.algorithm, versionTemplate.protectionalLevel" > $OUTPUTDIR/csv/$OUTPUKEY.csv
fi

for local in ${LOCATION[@]}; do
    KEYRINGS=$(gcloud kms keyrings list --location $local --project $PROJECT | awk 'NR>1{print $1}')
    for kr in ${KEYRINGS[@]}; do
        tmp=$(echo $kr | tr '/' ' ')
        declare -a tmparray=($tmp)
        filename=${tmparray[$((${#tmparray[@]} - 1))]}
        gcloud kms keyrings describe $kr --project $PROJECT --format=json | \
            tee -a $OUTPUTDIR/json/$OUTPUTRING/$filename-$PROJECT.json | jq -r -c '[.name,"'$PROJECT'",.createTime] | @csv' | \
            sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTRING.csv

        for key in $(gcloud kms keys list --keyring $kr --project $PROJECT | awk 'NR>1{print $1}') ; do
            tmp=$(echo $key | tr '/' ' ')
            declare -a tmparray=($tmp)
            filename=${tmparray[$((${#tmparray[@]} - 1))]}
            gcloud kms keys describe $key --project $PROJECT --format=json |\
                tee $OUTPUTDIR/json/$OUTPUKEY/$filename-$PROJECT.json | \
                jq -r -c '[.name,"'$PROJECT'",.primary.algorithm, .primary.generateTime, .primary.protectionLevel, .primary.state, .purpose, .versionTemplate.algorithm, .versionTemplate.protectionalLevel] | @csv' |\
                sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUKEY.csv
        done
    done
done

