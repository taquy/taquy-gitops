
import os
import glob

SECRET_FOLDER = './data/*'

if __name__ == "__main__":
	for fp in glob.iglob(SECRET_FOLDER):
		if not fp.lower().endswith(('.dec')):
			continue
		os.remove(fp)