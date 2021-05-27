**Deploy Infra**

```bash
aws s3 cp s3://taquy-deploy/setup-infra.sh ./ && chmod +x setup-infra.sh && bash setup-infra.sh
```



**Deploy App**

```bash
aws s3 cp s3://taquy-deploy/setup-app.sh ./ && chmod +x setup-app.sh && bash setup-app.sh
```



**Deploy Only API**

```bash
SERVICE_NAME=taquy-api
docker-compose stop $SERVICE_NAME && docker-compose pull $SERVICE_NAME && docker-compose up -d $SERVICE_NAME
```