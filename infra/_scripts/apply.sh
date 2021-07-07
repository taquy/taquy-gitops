#!/bin/bash

terraform apply "tf.plan"

# remove decrypted files
python /home/qt/.secrets/clean_decrypt.py
