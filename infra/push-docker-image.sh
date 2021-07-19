#!/bin/bash

PROJECT=$1
cd $PROJECT

PROJECT=taquy-backup-cron
REGION=ap-southeast-1
ACCOUNT=$(aws sts get-caller-identity | jq .Account -r )
REPOSITORY_URI=$ACCOUNT.dkr.ecr.$REGION.amazonaws.com

if [[ $PROJECT -eq "backup" ]]
then
  ARGS=$2
  docker build $ARGS . -t $REPOSITORY_URI/$PROJECT:latest
elif [[ $PROJECT -eq "fluentd" ]]
then
  docker build . -t $REPOSITORY_URI/$PROJECT:latest
elif [[ $PROJECT -eq "jenkins" ]]
then
  docker build . -t $REPOSITORY_URI/$PROJECT --build-arg root1234 --no-cache
elif [[ $PROJECT -eq "mssql" ]]
then
  docker pull mcr.microsoft.com/mssql/server:2019-latest
  docker tag mcr.microsoft.com/mssql/server:2019-latest $REPOSITORY_URI
elif [[ $PROJECT -eq "nginx" ]]
then
  docker build . -t $REPOSITORY_URI/$PROJECT:latest
fi

# delete untagged images (if there is any)
IMAGES_TO_DELETE=$(aws ecr list-images --region $REGION --repository-name $PROJECT --filter "tagStatus=UNTAGGED" --query 'imageIds[*]' --output json)
aws ecr batch-delete-image --region $REGION --repository-name $PROJECT --image-ids "$IMAGES_TO_DELETE" || true

docker push $REPOSITORY_URI/$PROJECT:latest