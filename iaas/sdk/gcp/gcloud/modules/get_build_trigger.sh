#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=build_trigger
SERVICE=cloudbuild.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
   exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

triggername=$(gcloud alpha builds triggers list --format=json --project $PROJECT | jq -r -c '.[]|.name')

echo "name, branchName, projectId, repoName ,filename" > $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
for name in ${triggername[@]}; do
    gcloud alpha builds triggers describe $name --project=$PROJECT --format=json |\
        tee $OUTPUTDIR/json/$OUTPUT/$name-$PROJECT.json |\
        jq -r -c '[.name, .triggerTemplate.branchName, .triggerTemplate.projectId, .triggerTemplate.repoName ,.filename] | @csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT-$PROJECT.csv
done

