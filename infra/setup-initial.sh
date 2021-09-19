#!/usr/bin/env bash

# on remote machine

# install awscli version 2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install -y jq unzip
unzip awscliv2.zip
rm -rf /usr/local/aws-cli/v2/2.2.39
./aws/install --update

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

# change hostname
hostnamectl set-hostname $USER
hostname $USER

# create user
mkdir -p $HOME $HOME/.ssh
groupadd $GROUP
useradd -g $GROUP -b $HOME $USER

# at local machine
scp -i ~/.ssh/taquy-vm -r ~/.ssh/taquy-vm.pub root@$REMOTE_HOST:/home/taquy/.ssh/authorized_keys
usermod -aG sudo $USER
usermod -d $HOME $USER

# disable root login or password login
nano /etc/ssh/sshd_config

#----------------------------------
ChallengeResponseAuthentication no
PasswordAuthentication no
UsePAM no
PubkeyAuthentication yes
AuthorizedKeysFile      .ssh/authorized_keys
AllowUsers taquy
#----------------------------------

systemctl reload ssh
systemctl reload sshd
chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys

# check current shell running
ps -p $$

# optional: change user password
passwd root
passwd taquy

# update permission of home folder
chown -R $USER:$GROUP $HOME

# create volume directory
echo "Create volume directory $DATA_DIR"
cd $DATA_DIR
mkdir -p $DATA_DIR
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
JENKINS_NODE_SECRET_JSON=$(aws secretsmanager list-secrets \
  --filters Key=tag-key,Values=Attributes \
  Key=tag-value,Values=taquy-jenkins-node-aws-key \
)
echo "Jenkins node secret info: $JENKINS_NODE_SECRET_JSON"

# get jenkins secret id
JENKINS_NODE_SECRET_ID=$(echo $JENKINS_NODE_SECRET_JSON | jq -r ".SecretList[0].Name")
echo "Jenkins secret id: $JENKINS_NODE_SECRET_ID"

JENKINS_NODE_SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id $JENKINS_NODE_SECRET_ID)
JENKINS_NODE_SECRET=$(echo $JENKINS_NODE_SECRET_JSON | jq -r ".SecretString")


# get access key, secrets
ACCESS_KEY=$(echo $JENKINS_NODE_SECRET | jq -rc '.id')
ACCESS_SECRET=$(echo $JENKINS_NODE_SECRET | jq -rc '.secret')
ROLE_ARN=$(echo $JENKINS_NODE_SECRET | jq -rc '.role')
echo "Jenkins role arn: $ROLE_ARN"

# config aws credentials
echo "Config aws credentials..."

# set profile for jenkins node
aws configure set aws_access_key_id $ACCESS_KEY --profile "jenkins-node"
aws configure set aws_secret_access_key $ACCESS_SECRET --profile "jenkins-node"
REGION=$(aws configure get region)
aws configure set region $REGION --profile "jenkins-node"
aws sts get-caller-identity --profile jenkins-node

# set profile for jenkins job
aws configure set role_arn $ROLE_ARN --profile "jenkins-job"
REGION=$(aws configure get region)
aws configure set region $REGION --profile "jenkins-job"
aws configure set source_profile "jenkins-node" --profile "jenkins-job"
aws sts get-caller-identity --profile jenkins-job

# copy configuration to $USER home
cp -r /root/.aws $HOME

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