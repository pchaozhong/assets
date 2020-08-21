#!/bin/sh

testExistTestNetwork()
{
    gcloud compute networks describe test > /dev/null 2>&1
    assertEquals $? 0
}

testCidrTestNetwork()
{
    assertEquals $(gcloud compute networks subnets describe test | grep ipCidrRange | awk '{print $2}') "192.168.1.0/29"
}

. shunit2