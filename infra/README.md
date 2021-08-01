**Initial Deploy**
```
# run bash sudo
bash <(curl -s https://taquy-deploy.s3.ap-southeast-1.amazonaws.com/setup-initial.sh) &
```

**Setup AMI**
```
# push ami scripts
aws s3 cp ./ami s3://taquy-deploy/ --recursive --acl public-read

# setup for arm64
curl -sf -L https://taquy-deploy.s3.ap-southeast-1.amazonaws.com/ubuntu-arm64.sh | sudo sh

# setup for x86_x64
curl -sf -L https://taquy-deploy.s3.ap-southeast-1.amazonaws.com/ubuntu-x86_64.sh | sudo sh

```

**Deploy Services**
```bash
bash push-docker-image.sh backup
bash push-docker-image.sh fluentd
bash push-docker-image.sh jenkins
bash push-docker-image.sh nginx
bash push-docker-image.sh mssql
bash push-docker-image.sh node
bash push-docker-image.sh compose
```

**Deploy Infra Stack**

```bash
aws s3 cp s3://taquy-deploy/setup-infra.sh ./ && chmod +x setup-infra.sh && bash setup-infra.sh
```


**Deploy Application Stack**
```bash
aws s3 cp s3://taquy-deploy/setup-app.sh ./ && chmod +x setup-app.sh && bash setup-app.sh
```

**Deploy Only API (App)**
```bash
SERVICE_NAME=taquy-api
docker-compose -f app.yml stop $SERVICE_NAME && docker-compose -f app.yml pull $SERVICE_NAME && docker-compose -f app.yml up -d $SERVICE_NAME
```


**Deploy Only Jenkins (Infra)**
```bash
SERVICE_NAME=jenkins
docker-compose -f infra.yml stop $SERVICE_NAME && docker-compose -f infra.yml pull $SERVICE_NAME && docker-compose -f infra.yml up -d $SERVICE_NAME
```

**Using docker buildx for multi arch**
```bash
docker buildx create --name taquy
docker buildx use taquy
docker buildx inspect --bootstrap
```

**Pricing EC2**
ap-southeast-1

instance type, specs, price per hour, price per month ($), price per month (millions VND)

amd
t4g.medium (- ECUs, 2 vCPUs, 2.5 GHz, -, 4 GiB memory, EBS only) 0.0127 = 9.45 = 0.221
t3.medium (- ECUs, 2 vCPUs, 2.5 GHz, -, 4 GiB memory, EBS only) 0.0158 = 11.7 = 0.275
t3.xlarge (- ECUs, 4 vCPUs, 2.5 GHz, -, 16 GiB memory, EBS only) 0.0634 = 47.16 = 1.1
c5.xlarge (- ECUs, 4 vCPUs, 3.4 GHz, -, 8 GiB memory, EBS only) 0.0691 = 51.41 = 1.2
cloudfly 4cpu 8mem = 0.726 (paid per hour) = 0.580 (paid per year)

arm
t4g.medium (- ECUs, 2 vCPUs, 2.5 GHz, -, 4 GiB memory, EBS only) 0.0127 = 9.45 = 0.221
t4g.xlarge (- ECUs, 4 vCPUs, 2.5 GHz, -, 16 GiB memory, EBS only) 0.0509 = 37.87 = 0.887

### Guide on using docker buildx
https://www.docker.com/blog/getting-started-with-docker-for-arm-on-linux/

*Setup Docker credential store*
https://www.techrepublic.com/article/how-to-setup-secure-credential-storage-for-docker/
```bash
wget https://github.com/docker/docker-credential-helpers/releases/download/v0.6.3/docker-credential-pass-v0.6.3-amd64.tar.gz

tar xvzf docker-credential-pass-v0.6.3-amd64.tar.gz

chmod a+x docker-credential-pass

cp docker-credential-pass /usr/local/bin
```