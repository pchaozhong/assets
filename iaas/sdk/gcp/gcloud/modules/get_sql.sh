#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=cloud_sql
SERVICE=sqladmin.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

instances=$(gcloud sql instances list --project $PROJECT | awk 'NR>1{print $1}')

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,gceZone,databaseVersion,serviceAccountEmailAddress,activationPolicy, availabilityType,backupRetentionSettings,backupRetentionretentionUnit, dataDiskSizeGb, dataDiskType" > $OUTPUTDIR/csv/$OUTPUT.csv
fi


for instance in ${instances[@]}; do
    gcloud sql instances describe --project $PROJECT --format json $instance |\
        tee $OUTPUTDIR/json/$OUTPUT/$instance-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.gceZone,.databaseVersion,.serviceAccountEmailAddress,.settings.activationPolicy, .settings.availabilityType, .settings.backupConfiguration.backupRetentionSettings.retainedBackups, .settings.backupConfiguration.backupRetentionSettings.retentionUnit, .settings.dataDiskSizeGb, .settings.dataDiskType]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done
