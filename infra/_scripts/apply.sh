#!/bin/bash

terraform apply "tf.plan"

# remove decrypted files
python /home/qt/.secrets/clean_decrypt.py

# delete gpg key
gpg --fingerprint --with-colons ${MAINTAINER_EMAIL} |\
    grep "^fpr" |\
    sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p' |\
    xargs gpg --batch --yes --delete-secret-keys
gpg --batch --yes --delete-key "$MAINTAINER_EMAIL"