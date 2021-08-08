#!/usr/bin/env bash

# run cloudwatch agent
echo "Start cloudwatch agent"
aws s3 cp s3://taquy-deploy/cw-agent.cfg ./
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:cw-agent.cfg

# define app user
echo "Define app user"
USER="taquy"
GROUP="taquy"
DATA_DIR="/data"
HOME="/home/$USER"
echo "user: $GROUP"
echo "data directory: $DATA_DIR"
echo "home directory: $HOME"

# create volume directory
echo "Create volume directory $DATA_DIR"
cd $DATA_DIR
mkdir -p es redis mongo tmp	portainer jenkins octopus mssql nginx certbot backup

cd $DATA_DIR/jenkins && mkdir -p cache logs home
cd $DATA_DIR/octopus && mkdir -p repository artifacts taskLogs cache import
cd $DATA_DIR/nginx && mkdir -p logs web
cd $DATA_DIR/certbot && mkdir -p logs ssl
cd $DATA_DIR/backup/ && mkdir logs archives

chown -R $USER:$GROUP $DATA_DIR
chmod u+rwx,g+rwx,o+r-wx -R $DATA_DIR

# get jenkins node id
echo "Finding jenkins node secret info..."
JENKINS_NODE_SECRET_ID=$(aws secretsmanager list-secrets \
  --filters Key=tag-key,Values=Attributes \
  Key=tag-value,Values=taquy-jenkins-node-aws-key \
)
echo "Jenkins node secret info: $JENKINS_NODE_SECRET_ID"

# get jenkins secret id
JENKINS_NODE_SECRET_ID=$(echo $JENKINS_NODE_SECRET_ID | jq -r ".SecretList[0].Name")
JENKINS_NODE_SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id $JENKINS_NODE_SECRET_ID)
JENKINS_NODE_SECRET=$(echo $JENKINS_NODE_SECRET_JSON | jq -r ".SecretString")
echo "Jenkins secret id: $JENKINS_NODE_SECRET_ID"

# get access key, secrets
ACCESS_KEY=$(echo $JENKINS_NODE_SECRET | jq -rc '. | fromjson | .id')
ACCESS_SECRET=$(echo $JENKINS_NODE_SECRET | jq -rc '. | fromjson | .secret')
ROLE_ARN=$(echo $JENKINS_NODE_SECRET | jq -rc '. | fromjson | .role')
echo "Jenkins role arn: $ROLE_ARN"

# config aws credentials
echo "Config aws credentials..."
aws configure set aws_access_key_id $ACCESS_KEY --profile "jenkins-node"
aws configure set aws_secret_access_key $ACCESS_SECRET --profile "jenkins-node"
aws configure set role_arn $ROLE_ARN --profile "jenkins-job"
aws configure set source_profile "jenkins-node" --profile "jenkins-job"

# run infra & app
echo "Starting run docker-compose infra and app..."
cd /home/$USER
aws s3 cp s3://taquy-deploy/setup-infra.sh ./ && bash setup-infra.sh
aws s3 cp s3://taquy-deploy/setup-app.sh ./ && bash setup-app.sh

# update permissions to app user
echo "Change permissions to $USER..."
chown -R $USER:$GROUP $DATA_DIR
chmod -R u+rwx,g+rwx,o+r-wx $DATA_DIR
chown -R "$USER":"$USER" $HOME
chmod -R g+rwx $HOME

# done
echo "Done."