#!/bin/bash
aws s3 cp s3://taquy-deploy/infra.yml ./

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

REPOSITORY_URI=397818416365.dkr.ecr.us-east-1.amazonaws.com
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPOSITORY_URI --password-stdin

docker-compose -f infra.yml up -d

rm -rf *