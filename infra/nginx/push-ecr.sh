#!/bin/bash
PROJECT=nginx
REGION=ap-southeast-1
REPOSITORY_URI=397818416365.dkr.ecr.$REGION.amazonaws.com
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REPOSITORY_URI --password-stdin

docker build . -t $REPOSITORY_URI/$PROJECT:latest

docker push $REPOSITORY_URI/$PROJECT:latest
