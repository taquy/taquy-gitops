#!/bin/bash
REGION=ap-southeast-1
ACCOUNT_ID=397818416365
REPOSITORY_URI=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REPOSITORY_URI --password-stdin
docker-compose -f infra.yml stop jenkins && \
docker-compose -f infra.yml pull jenkins && \
docker-compose -f infra.yml up jenkins &