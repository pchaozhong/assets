#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUT=build_trigger
SERVICE=cloudbuild.googleapis.com

echo "get glouc build trigger"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
   exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

triggername=$(gcloud alpha builds triggers list --format=json --project $PROJECT | jq -r -c '.[]|.name')

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,branchName, projectId, repoName ,filename" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

for name in ${triggername[@]}; do
    gcloud alpha builds triggers describe $name --project=$PROJECT --format=json |\
        tee $OUTPUTDIR/json/$OUTPUT/$name-$PROJECT.json |\
        jq -r -c '[.name,"'$PROJECT'" ,.triggerTemplate.branchName, .triggerTemplate.projectId, .triggerTemplate.repoName ,.filename] | @csv' |\
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
done

