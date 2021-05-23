#!/usr/bin/python
import os
import zipfile
import datetime;
import logging
import threading
import boto3
import glob

s3 = boto3.client('s3')

now = datetime.datetime.now()
now_ts = round(now.timestamp())
today = datetime.date.today()

year = today.year
month = '{:02d}'.format(today.month)
day = '{:02d}'.format(today.day)

# Define logs path
LOG_DIR_PATH = '/data/backup/logs'
LOG_FILE_PATH = '{folder}/{file_name}.log'.format(
  folder=LOG_DIR_PATH,
  file_name='{year}{month}{day}'.format(
    year=year, month=month, day=day
  )
)
logging.basicConfig(
  filename=LOG_FILE_PATH,
  filemode='a+',
  level=logging.INFO,
  format='[%(levelname)s]%(asctime)s.%(msecs)03d %(message)s',
  datefmt='%Y-%m-%d %H:%M:%S',
)

CONF_PATH = '/data/backup/conf/backup.conf'

# Define S3 backup path
BUCKET=os.getenv('BUCKET')
BACKUP_FOLDER = '/data/backup/archives'
BACKUP_FILE_NAME = '{}.zip'.format(now_ts)
BACKUP_FILE_PATH = '{folder}/{file_name}'.format(
  folder=BACKUP_FOLDER,
  file_name=BACKUP_FILE_NAME
)
BACKUP_STORE_PATH = '{year}/{month}/{day}/{file_name}'.format(
  year=year, month=month, day=day, file_name=BACKUP_FILE_NAME
)

def zipdir(path, ziph):
  for root, dirs, files in os.walk(path):
    for file in files:
      ziph.write(
        os.path.join(root, file), 
        os.path.relpath(
          os.path.join(root, file), 
          os.path.join(path, '..')
        )
      )

def empty_folder(folder_name: str):
  try:
    # empty archives folder
    files = glob.glob('{}/*.zip'.format(folder_name), recursive=True)
    for f in files:
      os.remove(f)
    return True
  except OSError as e:
    err = 'Unable to delete {file} with error {error}'.format(
      file=f, error=e.strerror
    )
    logging.error(err)
    return False
    
def create_zip_folder(lines):
  # create zip file recursively
  zipf = zipfile.ZipFile(BACKUP_FILE_PATH, 'w', zipfile.ZIP_DEFLATED)
  for folder_path in lines:
    zipdir(folder_path, zipf)
  zipf.close()
  

def backup():
  global BACKUP_FILE_PATH, BACKUP_STORE_PATH, CONF_PATH
  with open(CONF_PATH, 'r') as f:
    lines = f.readlines()
    lines = list(map(lambda x: x.strip('\n').strip('\t'), lines))
    if len(lines) == 0:
      logging.info('Upload {backup_path} to s3://{bucket}/{store_path}'.format(
        backup_path=BACKUP_FILE_PATH,
        store_path=BACKUP_STORE_PATH,
        bucket=BUCKET
      ))
      return
    
    create_zip_folder(lines)
   
    # upload to s3
    try:
      s3.meta.client.upload_file(
        BACKUP_STORE_PATH, BUCKET, BACKUP_FILE_NAME
      )
      
      is_error = empty_folder(BACKUP_FOLDER)
      
      if is_error:
        return

      # log events
      logging.info('Upload {backup_path} to s3://{bucket}/{store_path}'.format(
        backup_path=BACKUP_FILE_PATH,
        store_path=BACKUP_STORE_PATH,
        bucket=BUCKET
      ))
      
    except Exception as e:
      err = 'Unable to upload {file} to S3 with error {error}'.format(
        file=BACKUP_STORE_PATH, error=e.strerror
      )
      logging.error(err)
    
def run_backup_thread():
    worker = threading.Thread(target=backup)
    worker.start()

if __name__ == '__main__':
  run_backup_thread()