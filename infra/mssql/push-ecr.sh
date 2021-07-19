#!/bin/bash

ACCOUNT=$(aws sts get-caller-identity | jq .Account -r )

REGION=ap-southeast-1
REPOSITORY_URI=$ACCOUNT.dkr.ecr.$REGION.amazonaws.com/mssql

echo "Repository for mssql: $REPOSITORY_URI"

docker pull mcr.microsoft.com/mssql/server:2019-latest
docker tag  mcr.microsoft.com/mssql/server:2019-latest $REPOSITORY_URI

echo "Start pushing mssql docker image to $REPOSITORY_URI"
docker push $REPOSITORY_URI