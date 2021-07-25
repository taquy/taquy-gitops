
import os
import boto3
from botocore.config import Config
import glob

SECRET_FOLDER = './data/*'

kms_key_arn = os.environ["JENKINS_CREDENTIALS_KMS_KEY"]

config = Config(
    region_name = 'ap-southeast-1',
    retries = {
        'max_attempts': 2,
        'mode': 'standard'
    }
)

client = boto3.client('kms', config=config)

# reading secret files, encrypt each of them
if __name__ == "__main__":
	for fp in glob.iglob(SECRET_FOLDER):
		if fp.lower().endswith(('.dec')) or fp.lower().endswith(('.enc')):
			continue

		f = open(fp, 'r')
		content = f.read()
		f.close()

		response = client.encrypt(
		    KeyId=kms_key_arn,
		    Plaintext=content,
		)

		f = open(fp + '.enc', 'wb')
		f.write(response['CiphertextBlob'])
		f.close()

		os.remove(fp)