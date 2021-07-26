#!/bin/bash

# run taint for development purpose only
echo "Tainting spot instance..."
# bash run-taint.sh

# copy logs file to s3
echo "Upload logs config..."
aws s3 cp ./helpers/amazon-cloudwatch-agent.yml s3://taquy-deploy/amazon-cloudwatch-agent.yml

# push latest initialization script
echo "Pushing latest intial setup script..."
cd ..
bash push-docker-compose.sh
cd -

# decrypting secrets file
echo "Preparing secrets credentials..."
## run encrypt in case there are files haven't been encrypted yet
python ./helpers/encrypt.py

## run decrypt to get temporary decrypted values
python ./helpers/decrypt.py

# gpg credentials
echo "Generating new PGP key for IAM user secrets output..."
GPG_PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
echo $GPG_PASSWORD > "pgp-passphrase.txt"
export MAINTAINER_USERNAME='taquy'
export MAINTAINER_EMAIL='taquy.pb@gmail.com'

## delete previous gpg key
gpg --fingerprint --with-colons $MAINTAINER_EMAIL |\
    grep "^fpr" |\
    sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p' |\
    xargs gpg --batch --yes --delete-secret-keys
gpg --batch --yes --delete-key "$MAINTAINER_EMAIL"

## create gpg key to encrypt outputs credentials
yes | gpg --pinentry-mode loopback --trust-model always --passphrase "$GPG_PASSWORD" --quick-gen-key "$MAINTAINER_USERNAME <$MAINTAINER_EMAIL>"

## store public key in variable
PGP_PUBLIC_KEY=$(gpg --export $MAINTAINER_EMAIL | base64)

# prepare IP to whitelist
echo "Finding your IP to be whitelisted in IAM..."
MY_IP=$(curl checkip.amazonaws.com)
echo "Your current IP is $MY_IP"

# terraform workspace new taquy
echo "Start running creating terraform plan..."
terraform workspace select taquy &&
	terraform init &&
	terraform plan --out tf.plan --var-file=taquy.tfvars -var "my_ip=$MY_IP" -var "pgp_key=$PGP_PUBLIC_KEY"