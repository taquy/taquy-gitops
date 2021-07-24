#!/usr/bin/env bash
aws s3 cp s3://taquy-deploy/app.yml ./

# Create networks
docker network create -d bridge app

# Create docker volumes
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/es es-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/redis redis-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/mongo mongo-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/tmp app-vol

# Docker run
docker-compose -f app.yml up -d --quiet-pull

# Clean dangling images
docker rmi $(docker images -f dangling=true -q)
