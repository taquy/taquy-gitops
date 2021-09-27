#!/bin/bash
# Create networks
docker network create -d bridge infra

# Create docker volumes
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/portainer portainer-vol
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
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/nginx/conf nginx-conf-vol

docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/certbot/logs certbot-logs-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/certbot/conf certbot-conf-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/certbot/www certbot-www-vol

docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/backup/logs backup-logs-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/backup/archives backup-archives-vol

# Pull AWS secret for Jenkins node

# Pull nginx config
rm -r /data/nginx/conf || true
aws s3 cp s3://taquy-deploy/nginx-config.zip /data/nginx/nginx-config.zip
unzip /data/nginx/nginx-config.zip -d /data/nginx
rm /data/nginx/nginx-config.zip || true
mv /data/nginx/nginx/config /data/nginx/conf
rm -r /data/nginx/nginx || true

# Pull Jenkins CASC
aws s3 cp s3://taquy-deploy/jenkins-casc.yaml /data/jenkins/jenkins-casc.yaml


# Docker run
aws s3 cp s3://taquy-deploy/infra.yml ./
docker-compose -f infra.yml rm -f
docker-compose -f infra.yml pull
docker-compose -f infra.yml up -d --quiet

# Install SSL
# aws s3 cp s3://taquy-deploy/init-letsencrypt.sh ./
# chmod +x init-letsencrypt.sh
# ./init-letsencrypt.sh

# Clean dangling images
docker rmi $(docker images -f dangling=true -q)
