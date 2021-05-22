

```sh
REPOSITORY_URI=397818416365.dkr.ecr.ap-southeast-1.amazonaws.com/taquy-backup-cron
docker build . -t $REPOSITORY_URI

REPOSITORY_URI=397818416365.dkr.ecr.ap-southeast-1.amazonaws.com/taquy-backup-cron
aws ecr get-login-password --region us-east-1 | \
            docker login --username AWS --password-stdin $REPOSITORY_URI --password-stdin
docker push $REPOSITORY_URI

# test locally
REPOSITORY_URI=397818416365.dkr.ecr.ap-southeast-1.amazonaws.com/taquy-backup-cron
docker run -e schedule='* * * * *' \
    -e executor='/usr/local/bin/python3' \
    -e program='/app/backup.py' \
    $REPOSITORY_URI
```







