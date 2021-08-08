sudo -s

# define app user
USER="taquy"
GROUP="taquy"
DATA_DIR="/data"
HOME="/home/$USER"

# clean up previous app user
userdel -r $USER
rm -rf $HOME

# update systep
apt update
apt -y upgrade

## install python
apt install -y software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa -y
apt update
apt install -y python unzip python3-pip net-tools htop jq

## install cloudwatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

echo "Install cloudwatch agent"
dpkg -i -E ./amazon-cloudwatch-agent.deb

# Install aws-cli
echo "Start installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-`uname -m`.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
./aws/install --update

# set memory for VM
sysctl -w vm.max_map_count=262144

# change hostname
hostnamectl set-hostname $USER
HOSTNAME=$(hostnamectl)
echo "Changed hostname $HOSTNAME"

# create app group
groupdel $GROUP
groupadd -g 2000 -f $GROUP
echo "Created groups:" $(cat /etc/group | grep $GROUP)

# add user
useradd -m -g $GROUP -u 2000 $USER
echo -e "1\n1" | passwd $USER

# set user's primary group
usermod -g $GROUP $USER
echo "Created user:" $(getent passwd | awk -F: '{ print $1}' | grep $USER)

# create data directory
cd / && ls -la | grep 'data'
mkdir -p $DATA_DIR
chown -R $USER:$GROUP $DATA_DIR
chmod u+rwx,g+rwx,o+r-wx $DATA_DIR -R
cd / && ls -la | grep 'data'

# install cockpit
echo "Start installing Cockpit..."
apt install cockpit -y
systemctl start cockpit
systemctl enable cockpit
ufw allow 9090/tcp

# install docker
apt-get update -y
apt install -y docker.io
usermod -a -G docker $USER

# update docker permission
mkdir -p "$HOME/.docker" # for app user
mkdir -p /root/.docker # for root user
usermod -aG docker $USER
chown -R "$USER":"$USER" $HOME/.docker -R
chmod g+rwx "$HOME/.docker" -R

# install ecr helper (for instance)
echo "Start installing ECR helper..."
apt install -y amazon-ecr-credential-helper
printf '{\n\t"credsStore": "ecr-login"\n}\n' > $HOME/.docker/config.json
printf '{\n\t"credsStore": "ecr-login"\n}\n' > /root/.docker/config.json

# change permission to app user
chown -R "$USER":"$USER" $HOME -R
chmod g+rwx $HOME -R

# update latest packages after all installation
apt-get update -y
apt-get upgrade -y

# install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose