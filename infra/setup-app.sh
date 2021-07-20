#!/usr/bin/env bash
aws s3 cp s3://taquy-deploy/app.yml ./

# Setup memory for VM
sysctl -w vm.max_map_count=262144

# Create networks
docker network create -d bridge app

# Create docker volumes
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/es es-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/redis redis-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/mongo mongo-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/tmp app-vol

# Docker run
docker-compose -f app.yml pull
docker-compose -f app.yml up -d

# Clean dangling images
docker rmi $(docker images -f dangling=true -q)
