#!/bin/bash

# run taint for development purpose only
echo "Taint spot instance..."
bash run-taint.sh

# push latest initialization script 
echo "Push latest intial setup script..."
bash ../push-docker-compose.sh

# decrypting secrets file
echo "Preparing secrets credentials..."
## run encrypt in case there are files haven't been encrypted yet
python /home/qt/.secrets/encrypt.py

## run decrypt to get temporary decrypted values
python /home/qt/.secrets/decrypt.py

# gpg credentials
echo "Generating new PGP key for IAM user secrets output..."
GPG_PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
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