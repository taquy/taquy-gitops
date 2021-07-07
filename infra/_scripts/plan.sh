#!/bin/bash

# terraform workspace new taquy

# run encrypt in case there are files haven't been encrypted yet
python /home/qt/.secrets/encrypt.py

# run decrypt to get temporary decrypted values
python /home/qt/.secrets/decrypt.py

terraform workspace select taquy &&
	terraform init &&
	terraform plan --out tf.plan --var-file=taquy.tfvars