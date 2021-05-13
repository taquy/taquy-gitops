#!/bin/bash

aws s3 cp infra.yml s3://taquy-deployment/docker-compose-files
aws s3 cp app.yml s3://taquy-deployment/docker-compose-files
aws s3 cp setup.sh s3://taquy-deployment/docker-compose-files