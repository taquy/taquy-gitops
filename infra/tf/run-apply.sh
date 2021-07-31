#!/bin/bash

# remove decrypted files
echo "Remove decrypted files..."
python ./helpers/clean-up.py

# create plan
echo "Applying tf.plan..."
terraform apply "tf.plan"

# parse jenkins credentials from terraform output
JK_USER_SECRET_FILE="jenkins-secrets-file.txt"
echo "Jenkins node secrets will be stored at $JK_USER_SECRET_FILE"

# retrieve jenkins secret from output
echo "Retrieving jenkins secret from output..."
JK_SECRET_ID=$(terraform output -json | jq '.secret.value["jenkins-node-aws-key"].id' -r)
JK_USER_SECRET=$(terraform output -json | jq '.jenkins_node_user_key.value' -r)
echo "Retrieved jenkins secret id: $JK_SECRET_ID"

# parsing passphrase file
PGP_PASSPHRASE_FILE="pgp-passphrase.txt"
echo "Parsing passphrase file $PGP_PASSPHRASE_FILE"
PGP_PASSPHRASE=$(cat $PGP_PASSPHRASE_FILE)

# retrieving user id, secret, and role
JK_ID=$(echo $JK_USER_SECRET | jq '.id' -r)
echo $JK_USER_SECRET | jq '.secret' -r | base64 --decode > $JK_USER_SECRET_FILE
JK_SECRET=$(cat $JK_USER_SECRET_FILE | gpg --batch --yes --decrypt --passphrase $PGP_PASSPHRASE --pinentry-mode=loopback)
JK_ROLE=$(terraform output -json | jq '.jenkins_job_role_arn.value' -r)
echo "Retrieved jenkins secret id: $JK_ID"
echo "Retrieved jenkins role arn: $JK_ROLE"

# store jenkins node credentials to file
echo "Start storing jenkins node credentials to file..."
JK_USER_SECRET=$(jq -n \
    --arg id "$JK_ID" \
    --arg secret "$JK_SECRET" \
    --arg role "$JK_ROLE" \
    '{id: $id, secret: $secret}')
echo $JK_USER_SECRET > $JK_USER_SECRET_FILE

# update secrets
echo "Start updating jenkins node secrets on secret manager"
aws secretsmanager update-secret \
    --secret-id $JK_SECRET_ID \
    --secret-string file://$JK_USER_SECRET_FILE

# retrieving instance public ip
INSTANCE_PUBLIC_IP=$(terraform output -json | jq '.vm_public_ip.value' -r)
echo "Retrieved instance public ip: $INSTANCE_PUBLIC_IP"

# delete gpg key
echo "Deleting GPG key..."
gpg --fingerprint --with-colons ${MAINTAINER_EMAIL} |\
    grep "^fpr" |\
    sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p' |\
    xargs gpg --batch --yes --delete-secret-keys
gpg --batch --yes --delete-key "$MAINTAINER_EMAIL"

# clean up secret and gpg passphrase file 
echo "Clean up secret and gpg passphrase file..."
rm $JK_USER_SECRET_FILE
rm $PGP_PASSPHRASE_FILE

# ssh to the instance
echo "Start ssh into instance with ip $INSTANCE_PUBLIC_IP"
ssh-keygen -f "/home/qt/.ssh/known_hosts" -R $INSTANCE_PUBLIC_IP
ssh-keyscan $INSTANCE_PUBLIC_IP >> "/home/qt/.ssh/known_hosts"
ssh -i /home/qt/.ssh/taquy-vm ubuntu@$INSTANCE_PUBLIC_IP