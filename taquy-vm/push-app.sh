#!/bin/bash
aws s3 cp app.yml s3://taquy-deploy/
aws s3 cp setup-app.sh s3://taquy-deploy/