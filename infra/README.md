**Deploy Infra**

```bash
aws s3 cp s3://taquy-deploy/setup-infra.sh ./ && chmod +x setup-infra.sh && bash setup-infra.sh
```


**Deploy App**
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