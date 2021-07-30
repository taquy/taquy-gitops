#!/bin/bash

PROJECT=$1
cd $PROJECT

REGION=ap-southeast-1
ACCOUNT=$(aws sts get-caller-identity | jq .Account -r )
REPOSITORY_URI=$ACCOUNT.dkr.ecr.$REGION.amazonaws.com

if [[ $PROJECT -eq "backup" ]]
then
  ARGS=$2
  echo "Start building $PROJECT"
  docker build $ARGS . -t $REPOSITORY_URI/$PROJECT:latest
elif [[ $PROJECT -eq "fluentd" ]]
then
  echo "Start building $PROJECT"
  docker build . -t $REPOSITORY_URI/$PROJECT:latest
elif [[ $PROJECT -eq "node" ]]
then
  echo "Start building $PROJECT"
  docker build . -t $REPOSITORY_URI/$PROJECT:latest
elif [[ $PROJECT -eq "jenkins" ]]
then
  echo "Start building $PROJECT"
  docker build . -t $REPOSITORY_URI/$PROJECT --build-arg root1234 --no-cache
# build docker compose
elif [[ $PROJECT -eq "compose" ]]
then
  echo "Start building $PROJECT"
  bash setup.sh
  docker tag docker-compose:aarch64 $REPOSITORY_URI/$PROJECT:aarch64
  docker push $REPOSITORY_URI/$PROJECT:aarch64
elif [[ $PROJECT -eq "mssql" ]]
then
  echo "Start building $PROJECT"
  docker pull mcr.microsoft.com/mssql/server:2019-latest
  docker tag mcr.microsoft.com/mssql/server:2019-latest $REPOSITORY_URI
elif [[ $PROJECT -eq "nginx" ]]
then
  echo "Start building $PROJECT"
  docker build . -t $REPOSITORY_URI/$PROJECT:latest --no-cache
fi

docker push $REPOSITORY_URI/$PROJECT:latest

# delete untagged images (if there is any)
IMAGES_TO_DELETE=$(aws ecr list-images --region $REGION --repository-name $PROJECT --filter "tagStatus=UNTAGGED" --query 'imageIds[*]' --output json)
aws ecr batch-delete-image --region $REGION --repository-name $PROJECT --image-ids "$IMAGES_TO_DELETE" || true
