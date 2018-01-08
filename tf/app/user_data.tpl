#!/bin/bash

echo "ECS_CLUSTER=${cb-cluster}" >> /etc/ecs/ecs.config
echo "ECS_ENGINE_AUTH_TYPE=dockercfg" >> /etc/ecs/ecs.config
echo "ECS_ENGINE_AUTH_DATA={"https://index.docker.io/v1/":{"auth":"${auth}","email":"${email}"}}" >> /etc/ecs/ecs.config
echo "ECS_LOGLEVEL=debug" >> /etc/ecs/ecs.config

start ecs
