#!/bin/bash

# upload config
zip -r nginx-config.zip nginx/config/
aws s3 cp nginx-config.zip s3://taquy-deploy/nginx-config.zip
rm nginx-config.zip

# push app
aws s3 cp app.yml s3://taquy-deploy/
aws s3 cp setup-app.sh s3://taquy-deploy/

# push infra
aws s3 cp init-letsencrypt.sh s3://taquy-deploy
aws s3 cp infra.yml s3://taquy-deploy/
aws s3 cp setup-infra.sh s3://taquy-deploy/

# push initial deploy script
aws s3 cp ./setup-initial.sh s3://taquy-deploy/ --acl public-read

# aws s3 cp nginx-certbot s3://taquy-deploy/nginx-certbot --recursive
