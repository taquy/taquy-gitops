#!/usr/bin/env bash

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
apt install -y docker.io $USER
curl -L https://github.com/docker/compose/releases/download/1.28.5/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# update docker permission
mkdir -p "$HOME/.docker"
usermod -aG docker $USER
chown -R "$USER":"$USER" /home/"$USER"/.docker -R
chmod g+rwx "$HOME/.docker" -R

# install ecr helper (for instance)
apt install amazon-ecr-credential-helper
printf '{\n\t"credsStore": "ecr-login"\n}\n' > $HOME/.docker/config.json 

# install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
./aws/install

# install cockpit
apt install cockpit -y
systemctl start cockpit
systemctl enable cockpit
ufw allow 9090/tcp
 
# update latest packages after all installation
apt-get update -y
apt-get upgrade -y

# create volumes
mkdir -p /data
cd /data
mkdir -p es redis mongo tmp	portainer jenkins octopus mssql nginx certbot backup

cd /data/jenkins && mkdir -p cache logs home
cd /data/octopus && mkdir -p repository artifacts taskLogs cache import
cd /data/nginx && mkdir -p logs web
cd /data/certbot && mkdir -p logs ssl
cd /data/backup/ && mkdir logs archives

chown -R $USER:$GROUP $DATA_DIR
chmod u+rwx,g+rwx,o+r-wx -R $DATA_DIR

# Setup memory for VM
sysctl -w vm.max_map_count=262144

# Switch to main user
sudo su - $USER << EOF
# run infra & app
cd /home/$USER
aws s3 cp s3://taquy-deploy/setup-infra.sh ./ && bash setup-infra.sh
aws s3 cp s3://taquy-deploy/setup-app.sh ./ && bash setup-app.sh
EOF
