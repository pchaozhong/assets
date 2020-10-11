#!/bin/sh

PROJECT=$1
OUTPUTDIR=$2
OUTPUTCL=gke_cluster
OUTPUTND=gke_node
SERVICE=container.googleapis.com

echo "get gke cluster"

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUTCL ]; then
    mkdir $OUTPUTDIR/json/$OUTPUTCL
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUTND ]; then
    mkdir $OUTPUTDIR/json/$OUTPUTND
fi

declare -a clusters=($(gcloud container clusters list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a regions=($(gcloud container clusters list --project $PROJECT | awk 'NR>1{print $2}'))

if [ ! -e $OUTPUTDIR/csv/$OUTPUTCL.csv ]; then
    echo "name,project,network,subnetwork,endpoint,clusterIpv4Cidr,currentMasterVersion,currentNodeCount,currentNodeVersion,databaseEncryption.state,defaultMaxPodsConstraint.maxPodsPerNode,nodeConfig.diskSizeGb,nodeConfig.diskType,nodeConfig.imageType,nodeConfig.machineType,locations" > $OUTPUTDIR/csv/$OUTPUTCL.csv
fi

if [ ! -e $OUTPUTDIR/csv/$OUTPUTND.csv ]; then
    echo "name,project,imageType,diskSizeGb,diskType,machineType,serviceAccount,podIpv4CidrSize,maxSurge,version" > $OUTPUTDIR/csv/$OUTPUTND.csv
fi

count=0

while [ $count -lt ${#clusters[@]} ]; do
    gcloud container clusters describe --project $PROJECT --region ${regions[$count]} --format=json ${clusters[$count]} |\
        tee $OUTPUTDIR/json/$OUTPUTCL/${clusters[$count]}-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.network, .subnetwork ,.endpoint,.clusterIpv4Cidr,.currentMasterVersion,.currentNodeCount,.currentNodeVersion,.databaseEncryption.state,.defaultMaxPodsConstraint.maxPodsPerNode, .nodeConfig.diskSizeGb, .nodeConfig.diskType, .nodeConfig.imageType, .nodeConfig.machineType, .locations[]] | @csv' | \
            sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTCL.csv

    nodes=$(gcloud container node-pools list --project $PROJECT --cluster ${clusters[$count]} --region ${regions[$count]} | awk 'NR>1{print $1}')

    for node in ${nodes[@]}; do
        gcloud container node-pools describe --project $PROJECT  --cluster ${clusters[$count]} --region ${regions[$count]} $node --format=json |\
            tee $OUTPUTDIR/json/$OUTPUTND/$node-${clusters[$count]}-$PROJECT.json |\
            jq -r -c '[.name,"'$PROJECT'",.config.imageType,.config.diskSizeGb, .config.diskType, .config.machineType, .config.serviceAccount, .podIpv4CidrSize, .upgradeSettings.maxSurge, .version]|@csv' |\
            sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUTND.csv
    done

    count=$(( $count + 1 ))
done

