#!/bin/bash

aws s3 cp nginx/init-letsencrypt.sh s3://taquy-deploy
aws s3 cp infra.yml s3://taquy-deploy/
aws s3 cp setup-infra.sh s3://taquy-deploy/
