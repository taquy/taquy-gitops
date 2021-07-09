#!/bin/bash
aws s3 cp ./setup-initial.sh s3://taquy-deploy/ --acl public-read

bash push-infra.sh
bash push-app.sh
