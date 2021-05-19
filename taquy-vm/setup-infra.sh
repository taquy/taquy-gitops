#!/bin/bash
aws s3 cp s3://taquy-deploy/infra.yml ./

# create folder for infra
mkdir -p /data/jenkins/cache /data/jenkins/logs /data/jenkins/home 
mkdir -p /data/octopus/repository 
mkdir -p /data/octopus/artifacts 
mkdir -p /data/octopus/taskLogs 
mkdir -p /data/octopus/cache 
mkdir -p /data/octopus/import 
mkdir -p /data/mssql
mkdir -p /data/nginx/logs /data/nginx/web
mkdir -p /data/certbot/logs /data/certbot/ssl

chmod -R 775 /data

# Create networks
docker network create -d bridge infra

# Create docker volumes
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/jenkins/home jenkins-home-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/jenkins/cache jenkins-cache-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/jenkins/logs jenkins-logs-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/octopus/repository octopus-repository-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/octopus/artifacts octopus-artifacts-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/octopus/taskLogs octopus-taskLogs-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/octopus/cache octopus-cache-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/octopus/import octopus-import-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/mssql mssql-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/nginx/logs nginx-logs-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/nginx/web nginx-web-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/certbot/logs certbot-logs-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/certbot/ssl certbot-ssl-vol

# ECR Login
REGION=ap-southeast-1
ACCOUNT_ID=397818416365
REPOSITORY_URI=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REPOSITORY_URI --password-stdin

# Docker run
docker-compose -f infra.yml pull
docker-compose -f infra.yml up -d

# Install SSL
aws s3 cp s3://taquy-deploy/init-letsencrypt.sh ./
chmod +x init-letsencrypt.sh
sudo ./init-letsencrypt.sh

# Clean dangling images
docker rmi $(docker images -f dangling=true -q)