#!/bin/bash
ARGS=$1

echo $ARGS
PROJECT=taquy-backup-cron
REGION=ap-southeast-1
REPOSITORY_URI=397818416365.dkr.ecr.$REGION.amazonaws.com
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REPOSITORY_URI --password-stdin
docker build $ARGS . -t $REPOSITORY_URI/$PROJECT:latest 
docker push $REPOSITORY_URI/$PROJECT:latest