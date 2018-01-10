#!/bin/bash

## This script is taking the version wanted to be deployed as the only a parameter

CONTAINER_ID=`sudo docker ps |awk '/prototype/ {print \$1}'`
APPLICATION="rafabor/prototype-4-cb"
NEW_VERSION=$1
CURRENT_VERSION=`sudo docker ps |awk '/prototype/ {print \$2}'|awk -F ":" '{print \$2}'`

echo "Current app version running:    " $APPLICATION":"$CURRENT_VERSION
echo "New app version to be deployed: " $APPLICATION":"$NEW_VERSION
echo "Container ID running the app:   "$CONTAINER_ID

docker pull $APPLICATION":"$NEW_VERSION
docker stop $CONTAINER_ID
docker rm $CONTAINER_ID
docker rmi -f $APPLICATION":"$CURRENT_VERSION  
docker run -p 0.0.0.0:5555:5555 $APPLICATION":"$NEW_VERSION
