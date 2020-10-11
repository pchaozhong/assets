#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=instance_group
SERVICE=compute.googleapis.com

echo "get instance group"

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

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,network,size,subnetwork,zone" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

count=0

while [ $count -lt ${#instance_groups_name[@]} ]; do
    gcloud compute instance-groups describe --${instance_groups_scope[$count]} ${instance_groups_location[$count]} --project $PROJECT --format json ${instance_groups_name[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUT/${instance_groups_name[$count]}-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'",.network,.size,.subnetwork,.zone]|@csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done
