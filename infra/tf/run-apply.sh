#!/bin/bash

# create plan
terraform apply "tf.plan"

# remove decrypted files
python /home/qt/.secrets/clean_decrypt.py

# delete gpg key
gpg --fingerprint --with-colons ${MAINTAINER_EMAIL} |\
    grep "^fpr" |\
    sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p' |\
    xargs gpg --batch --yes --delete-secret-keys
gpg --batch --yes --delete-key "$MAINTAINER_EMAIL"

# parse jenkins credentials from terraform output
JENKINS_NODE_SECRET_ID=$(terraform output -json | jq '.secret.value["instance-ssh-key"].id' -r)
JENKINS_NODE_USER_KEY=$(terraform output -json | jq '.iam.jenkins_node_user_key' -r)

# update secrets
aws secretsmanager update-secret \
    --secret-id $JENKINS_NODE_SECRET_ID \
    --kms-key-id $JENKINS_CREDENTIALS_KMS_KEY \
    --secret-string $JENKINS_NODE_USER_KEY

INSTANCE_PUBLIC_IP=$(terraform output -json | jq '.vm_public_ip.value' -r)

echo "Launched instance public ip $INSTANCE_PUBLIC_IP"
# ssh to new instance
ssh-keygen -f "/home/qt/.ssh/known_hosts" -R $INSTANCE_PUBLIC_IP
ssh -i /home/qt/.ssh/taquy-vm ubuntu@$INSTANCE_PUBLIC_IP

