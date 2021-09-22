#!/bin/bash

PROJECT=$1
cd $PROJECT

REGION=ap-southeast-1
ACCOUNT=$(aws sts get-caller-identity | jq .Account -r )
REPOSITORY_URI=$ACCOUNT.dkr.ecr.$REGION.amazonaws.com

if [[ $PROJECT == "nginx" ]]
then
  echo "Upload config of $PROJECT"
  aws s3 cp nginx/nginx.conf s3://taquy-deploy/nginx.conf
fi

echo "Start building $PROJECT"

if [[ $PROJECT == "mssql" ]]
then
  docker pull mcr.microsoft.com/mssql/server:2019-latest
  docker tag mcr.microsoft.com/mssql/server:2019-latest $REPOSITORY_URI
else
  echo "Build and push image for $REPOSITORY_URI/$PROJECT"
  docker buildx build --platform linux/arm64 --tag $REPOSITORY_URI/$PROJECT:arm64 --push .
  docker buildx build --platform linux/amd64 --tag $REPOSITORY_URI/$PROJECT:amd64 --push .
fi

docker buildx imagetools inspect $REPOSITORY_URI/$PROJECT 

# delete untagged images (if there is any)
IMAGES_TO_DELETE=$(aws ecr list-images --region $REGION --repository-name $PROJECT --filter "tagStatus=UNTAGGED" --query 'imageIds[*]' --output json)
aws ecr batch-delete-image --region $REGION --repository-name $PROJECT --image-ids "$IMAGES_TO_DELETE" || true
