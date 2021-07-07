
**Build & Push script
```bash
# build with cache
bash push-ecr.sh

# build without cache
bash push-ecr.sh --no-cache
```


**Build docker image**

```bash
REPOSITORY_URI=397818416365.dkr.ecr.ap-southeast-1.amazonaws.com/taquy-backup-cron

# build with cache
docker build . -t $REPOSITORY_URI

# build without cache
docker build . -t $REPOSITORY_URI --no-cache
```



**Push docker image**

```sh
REPOSITORY_URI=397818416365.dkr.ecr.ap-southeast-1.amazonaws.com/taquy-backup-cron
aws ecr get-login-password --region us-east-1 | \
            docker login --username AWS --password-stdin $REPOSITORY_URI --password-stdin
docker push $REPOSITORY_URI
```



**Test docker image locally**

```sh
REPOSITORY_URI=397818416365.dkr.ecr.ap-southeast-1.amazonaws.com/taquy-backup-cron
docker run -e schedule='* * * * *' \
    -e executor='/usr/local/bin/python3' \
    -e program='/app/backup.py' \
    $REPOSITORY_URI

```

