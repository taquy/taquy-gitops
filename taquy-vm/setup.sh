#!/bin/bash

# create folder for infra
mkdir -p /data/jenkins/cache
mkdir -p /data/jenkins/logs 
mkdir -p /data/octopus/repository 
mkdir -p /data/octopus/artifacts 
mkdir -p /data/octopus/taskLogs 
mkdir -p /data/octopus/cache 
mkdir -p /data/octopus/import 
mkdir -p /data/mssql
mkdir -p /data/nginx/logs

chmod -R 775 /data

docker-compose -f infra.yml up