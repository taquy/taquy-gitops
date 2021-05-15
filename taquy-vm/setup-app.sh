
#!/usr/bin/env bash
aws s3 cp s3://taquy-deploy/app.yml ./

# Setup memory for VM
sysctl -w vm.max_map_count=262144

# Create volume folder
mkdir -p /data/es 
mkdir -p /data/mongo
mkdir -p /data/redis 
mkdir -p /data/tmp

# ECR Login
REGION=ap-southeast-1
REPOSITORY_URI=397818416365.dkr.ecr.$REGION.amazonaws.com
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REPOSITORY_URI --password-stdin

# Docker run
docker-compose -f app.yml pull
docker-compose -f app.yml up -d