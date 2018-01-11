#!/bin/bash

CLUSTER="cb-prototype-cluster"
SERVICE=`aws ecs list-services --cluster $CLUSTER |jq -r '.serviceArns[]'`
DESIRED_COUNT=$1
TASK_VERSION=`aws ecs list-task-definitions |jq -r '.taskDefinitionArns[]'`

echo "About to deploy: $TASK_VERSION"
aws ecs update-service --cluster $CLUSTER --service $SERVICE --desired-count $DESIRED_COUNT --task-definition $TASK_VERSION 
