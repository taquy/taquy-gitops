#!/bin/bash

PROJECT=$1
cd $PROJECT

REGION=ap-southeast-1
ACCOUNT=$(aws sts get-caller-identity | jq .Account -r )
REPOSITORY_URI=$ACCOUNT.dkr.ecr.$REGION.amazonaws.com

if [[ $PROJECT == "backup" ]]
then
  ARGS=$2
  echo "Start building backup"
  docker build $ARGS . -t $REPOSITORY_URI/$PROJECT:latest
elif [[ $PROJECT == "fluentd" ]]
then
  echo "Start building fluentd"
  docker build . -t $REPOSITORY_URI/$PROJECT:latest
elif [[ $PROJECT == "node" ]]
then
  echo "Start building node"
  docker build . -t $REPOSITORY_URI/$PROJECT:latest
elif [[ $PROJECT == "jenkins" ]]
then
  echo "Start building jenkins"
  docker build . -t $REPOSITORY_URI/$PROJECT --build-arg root1234 --no-cache
elif [[ $PROJECT == "mssql" ]]
then
  echo "Start building mssql"
  docker pull mcr.microsoft.com/mssql/server:2019-latest
  docker tag mcr.microsoft.com/mssql/server:2019-latest $REPOSITORY_URI
elif [[ $PROJECT == "nginx" ]]
then
  echo "Start building nginx"
  docker build . -t $REPOSITORY_URI/$PROJECT:latest --no-cache
fi

docker push $REPOSITORY_URI/$PROJECT:latest

# delete untagged images (if there is any)
IMAGES_TO_DELETE=$(aws ecr list-images --region $REGION --repository-name $PROJECT --filter "tagStatus=UNTAGGED" --query 'imageIds[*]' --output json)
aws ecr batch-delete-image --region $REGION --repository-name $PROJECT --image-ids "$IMAGES_TO_DELETE" || true
