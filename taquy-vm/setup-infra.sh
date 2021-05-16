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
mkdir -p /data/nginx/logs /data/nginx/web
mkdir -p /data/certbot/logs /data/certbot/ssl

chmod -R 775 /data

# ECR Login
REGION=ap-southeast-1
REPOSITORY_URI=397818416365.dkr.ecr.$REGION.amazonaws.com
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REPOSITORY_URI --password-stdin

# Docker run
docker-compose -f infra.yml pull
docker-compose -f infra.yml up -d

# Install SSL
aws s3 cp s3://taquy-deploy/init-letsencrypt.sh ./
chmod +x init-letsencrypt.sh
sudo ./init-letsencrypt.sh