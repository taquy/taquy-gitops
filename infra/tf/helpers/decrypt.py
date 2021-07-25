
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
		if not fp.lower().endswith(('.enc')):
			continue

		f = open(fp, "rb")
		content = f.read()
		f.close()

		response = client.decrypt(
		    CiphertextBlob=content,
		    KeyId=kms_key_arn,
		)
		decrypted_text = response['Plaintext'].decode('utf-8')

		f = open(fp + '.dec', "w")
		f.write(decrypted_text)
		f.close()




