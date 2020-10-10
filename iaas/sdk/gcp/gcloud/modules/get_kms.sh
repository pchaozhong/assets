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

echo "name,createTime" > $OUTPUTDIR/csv/$OUTPUTRING-$PROJECT.csv
echo "name, primary.algorithm, primary.generateTime, primary.protectionLevel, primary.state, purpose, versionTemplate.algorithm, versionTemplate.protectionalLevel" > $OUTPUTDIR/csv/$OUTPUKEY-$PROJECT.csv
for local in ${LOCATION[@]}; do
    KEYRINGS=$(gcloud kms keyrings list --location $local --project $PROJECT | awk 'NR>1{print $1}')
    for kr in ${KEYRINGS[@]}; do
        tmp=$(echo $kr | tr '/' ' ')
        declare -a tmparray=($tmp)
        filename=${tmparray[$((${#tmparray[@]} - 1))]}
        gcloud kms keyrings describe $kr --project $PROJECT --format=json | \
            tee -a $OUTPUTDIR/json/$OUTPUTRING/$filename-$PROJECT.json | jq -r -c '[.name, .createTime] | @csv' | \
            sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTRING-$PROJECT.csv

        for key in $(gcloud kms keys list --keyring $kr --project $PROJECT | awk 'NR>1{print $1}') ; do
            tmp=$(echo $key | tr '/' ' ')
            declare -a tmparray=($tmp)
            filename=${tmparray[$((${#tmparray[@]} - 1))]}
            gcloud kms keys describe $key --project $PROJECT --format=json |\
                tee $OUTPUTDIR/json/$OUTPUKEY/$filename-$PROJECT.json | \
                jq -r -c '[.name, .primary.algorithm, .primary.generateTime, .primary.protectionLevel, .primary.state, .purpose, .versionTemplate.algorithm, .versionTemplate.protectionalLevel] | @csv' |\
                sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUKEY-$PROJECT.csv
        done
    done
done

