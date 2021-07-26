#!/bin/bash

# create plan
terraform apply "tf.plan"

# remove decrypted files
python ./helpers/clean-up.py

# parse jenkins credentials from terraform output
JK_USER_SECRET_FILE="jenkins-secrets-file.txt"

JK_SECRET_ID=$(terraform output -json | jq '.secret.value["jenkins-node-aws-key"].id' -r)
JK_USER_SECRET=$(terraform output -json | jq '.jenkins_node_user_key.value' -r)

PGP_PASSPHRASE_FILE="pgp-passphrase.txt"
PGP_PASSPHRASE=$(cat $PGP_PASSPHRASE_FILE)

JK_ID=$(echo $JK_USER_SECRET | jq '.id' -r)
echo $JK_USER_SECRET | jq '.secret' -r | base64 --decode > $JK_USER_SECRET_FILE
JK_SECRET=$(cat $JK_USER_SECRET_FILE | gpg --batch --yes --decrypt --passphrase $PGP_PASSPHRASE --pinentry-mode=loopback)
JK_ROLE=$(terraform output -json | jq '.jenkins_job_role_arn.value' -r)

JK_USER_SECRET=$(jq -n \
    --arg id "$JK_ID" \
    --arg secret "$JK_SECRET" \
    --arg role "$JK_ROLE" \
    '{id: $id, secret: $secret}')
echo $JK_USER_SECRET > $JK_USER_SECRET_FILE

# update secrets
aws secretsmanager update-secret \
    --secret-id $JK_SECRET_ID \
    --secret-string file://$JK_USER_SECRET_FILE

INSTANCE_PUBLIC_IP=$(terraform output -json | jq '.vm_public_ip.value' -r)

# delete gpg key
gpg --fingerprint --with-colons ${MAINTAINER_EMAIL} |\
    grep "^fpr" |\
    sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p' |\
    xargs gpg --batch --yes --delete-secret-keys
gpg --batch --yes --delete-key "$MAINTAINER_EMAIL"

rm $JK_USER_SECRET_FILE
rm $PGP_PASSPHRASE_FILE

echo "Launched instance public ip $INSTANCE_PUBLIC_IP"
# ssh to new instance
ssh-keygen -f "/home/qt/.ssh/known_hosts" -R $INSTANCE_PUBLIC_IP
ssh -i /home/qt/.ssh/taquy-vm ubuntu@$INSTANCE_PUBLIC_IP

