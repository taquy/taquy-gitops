#!/bin/bash

# push app
aws s3 cp app.yml s3://taquy-deploy/
aws s3 cp setup-app.sh s3://taquy-deploy/

# push infra
aws s3 cp nginx/init-letsencrypt.sh s3://taquy-deploy
aws s3 cp infra.yml s3://taquy-deploy/
aws s3 cp setup-infra.sh s3://taquy-deploy/

# push initial deploy script
aws s3 cp ./setup-initial.sh s3://taquy-deploy/ --acl public-read
