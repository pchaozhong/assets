#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=instance_group
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

declare -a instance_groups_name=($(gcloud compute instance-groups list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a instance_groups_scope=($(gcloud compute instance-groups list --project $PROJECT | awk 'NR>1{print $3}'))
declare -a instance_groups_location=($(gcloud compute instance-groups list --project $PROJECT | awk 'NR>1{print $2}'))

if [ -z $instance_groups_name ] ;then
    exit 0
fi

echo "name,network,size,subnetwork,zone" > $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
count=0

while [ $count -lt ${#instance_groups_name[@]} ]; do
    gcloud compute instance-groups describe --${instance_groups_scope[$count]} ${instance_groups_location[$count]} --project $PROJECT --format json ${instance_groups_name[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUT/${instance_groups_name[$count]}-$PROJECT.json |\
        jq -r -c '[.name,.network,.size,.subnetwork,.zone]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
    count=$(( $count + 1 ))
done
