#!/bin/sh

# PROJECT=$1
# OUTPUTDIR=$2
# OUTPUT=container_registory
# SERVICE=containerregistry.googleapis.com

# echo "get container registory"

# grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

# if [ $? != 0 ]; then
#     exit 0
# fi

# if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
#     mkdir $OUTPUTDIR/json/$OUTPUT
# fi

# if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
#     echo "name,project,registry,repository" > $OUTPUTDIR/csv/$OUTPUT.csv
# fi

# containers=$(gcloud container images list --project $PROJECT | awk 'NR>1{print $1}')

# for container in ${containers[@]}; do
#     tmp=$(echo $container | tr '/' ' ')
#     declare -a tmparray=($tmp)
#     filename=${tmparray[$((${#tmparray[@]} - 1))]}

#     gcloud container images describe --project $PROJECT --format json $container |\
#         tee $OUTPUTDIR/json/$OUTPUT/$filename-$PROJECT.json |\
#         jq -r -c '["'$filename'","'$PROJECT'",.image_summary.registry,.image_summary.repository]|@csv' |\
#         sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
# done
