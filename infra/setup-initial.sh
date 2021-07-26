#!/usr/bin/env bash

# install cloudwatch logs agent
apt update
apt -y upgrade
apt install -y software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa -y
apt update
apt install -y python
curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
chmod +x ./awslogs-agent-setup.py
./awslogs-agent-setup.py -n -r ap-southeast-1 -c s3://taquy-deploy/amazon-cloudwatch-agent.yml

# install tools
apt install -y net-tools unzip

USER="taquy"
GROUP="taquy"
DATA_DIR="/data"
HOME="/home/$USER"

userdel -r $USER
rm -rf $HOME

groupdel $GROUP
groupadd -g 2000 -f $GROUP
echo "Created groups:" $(cat /etc/group | grep $GROUP)

useradd -m -g $GROUP -u 2000 $USER
echo -e "1\n1" | passwd $USER
# change primary group
usermod -g $GROUP $USER
echo "Created user:" $(getent passwd | awk -F: '{ print $1}' | grep $USER)

# create data directory
cd / && ls -la | grep 'data'
mkdir -p $DATA_DIR
chown -R $USER:$GROUP $DATA_DIR
chmod u+rwx,g+rwx,o+r-wx $DATA_DIR -R
cd / && ls -la | grep 'data'

# install docker & docker-compose
apt-get update -y
apt install -y docker.io
curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
usermod -a -G docker $USER

# update docker permission
mkdir -p "$HOME/.docker" # for app user
mkdir -p /root/.docker # for root user
usermod -aG docker $USER
chown -R "$USER":"$USER" $HOME/.docker -R
chmod g+rwx "$HOME/.docker" -R

# update latest packages after all installation
apt-get update -y
apt-get upgrade -y

# install ecr helper (for instance)
echo "Start installing ECR helper..."
apt install -y amazon-ecr-credential-helper
printf '{\n\t"credsStore": "ecr-login"\n}\n' > $HOME/.docker/config.json
printf '{\n\t"credsStore": "ecr-login"\n}\n' > /root/.docker/config.json

# install aws-cli
echo "Start installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
./aws/install

# install cockpit
echo "Start installing Cockpit..."
apt install cockpit -y
systemctl start cockpit
systemctl enable cockpit
ufw allow 9090/tcp

# change permission to official user
chown -R "$USER":"$USER" $HOME -R
chmod g+rwx $HOME -R

# create volumes
cd $DATA_DIR
mkdir -p es redis mongo tmp	portainer jenkins octopus mssql nginx certbot backup

cd $DATA_DIR/jenkins && mkdir -p cache logs home
cd $DATA_DIR/octopus && mkdir -p repository artifacts taskLogs cache import
cd $DATA_DIR/nginx && mkdir -p logs web
cd $DATA_DIR/certbot && mkdir -p logs ssl
cd $DATA_DIR/backup/ && mkdir logs archives

chown -R $USER:$GROUP $DATA_DIR
chmod u+rwx,g+rwx,o+r-wx -R $DATA_DIR

# Setup memory for VM
sysctl -w vm.max_map_count=262144

# setup jenkins node service account secret
apt install -y jq

# aws secretsmanager list-secrets

JENKINS_NODE_SECRET=$(aws secretsmanager get-secret-value --secret-id taquy-jenkins-node-aws-key | jq .SecretString)
ACCESS_KEY=$(echo $JENKINS_NODE_SECRET | jq -rc '. | fromjson | .id')
ACCESS_SECRET=$(echo $JENKINS_NODE_SECRET | jq -rc '. | fromjson | .secret')
ROLE_ARN=$(echo $JENKINS_NODE_SECRET | jq -rc '. | fromjson | .role')
aws configure set aws_access_key_id $ACCESS_KEY --profile "jenkins-node"
aws configure set aws_secret_access_key $ACCESS_SECRET --profile "jenkins-node"

aws configure set role_arn $ROLE_ARN --profile "jenkins-job"
aws configure set source_profile "jenkins-node" --profile "jenkins-job"

# run infra & app
cd /home/$USER
aws s3 cp s3://taquy-deploy/setup-infra.sh ./ && bash setup-infra.sh
aws s3 cp s3://taquy-deploy/setup-app.sh ./ && bash setup-app.sh

chown -R $USER:$GROUP $DATA_DIR
chmod -R u+rwx,g+rwx,o+r-wx $DATA_DIR
chown -R "$USER":"$USER" $HOME
chmod -R g+rwx $HOME