#!/bin/sh

echo "get vpn tunnel"
PROJECT=$1
OUTPUTDIR=$2
OUTPUT=vpn_tunnel
SERVICE=compute.googleapis.com

grep $SERVICE $OUTPUTDIR/json/service_list/$PROJECT.txt

if [ $? != 0 ]; then
    exit 0
fi

if [ ! -d $OUTPUTDIR/json/$OUTPUT ]; then
    mkdir $OUTPUTDIR/json/$OUTPUT
fi

declare -a vpn_tunnels=($(gcloud compute vpn-tunnels list --project $PROJECT | awk 'NR>1{print $1}'))
declare -a regions=($(gcloud compute vpn-tunnels list --project $PROJECT | awk 'NR>1{print $2}'))

if [ ! -e $OUTPUTDIR/csv/$OUTPUT.csv ]; then
    echo "name,project,ikeVersion,peerGcpGateway,peerIp,region,vpnGateway,vpnGatewayInterface" > $OUTPUTDIR/csv/$OUTPUT.csv
fi

count=0
while [ $count -lt ${#vpn_tunnels[@]} ]; do
    gcloud compute vpn-tunnels describe --format json --project $PROJECT --region ${regions[$count]} ${vpn_tunnels[$count]} |\
        tee -a $OUTPUTDIR/json/$OUTPUT/${vpn_tunnels[$count]}-$PROJECT.json | \
        jq -r -c '[.name,"'$PROJECT'",.ikeVersion,.peerGcpGateway,.peerIp,.region,.vpnGateway,.vpnGatewayInterface] | @csv' | \
        sed -e 's/"//g' >> $OUTPUTDIR/csv/$OUTPUT.csv
    count=$(( $count + 1 ))
done
