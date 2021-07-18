

# install tools
sudo apt install -y net-tools unzip

USER=${1:-taquy}
GROUP=${1:-taquy}
DATA_DIR=${1:-'/data'}
HOME=/home/$USER

sudo userdel -r $USER
sudo rm -rf $HOME

sudo groupdel $GROUP
sudo groupadd -g 2000 -f $GROUP
echo "Created groups:" $(cat /etc/group | grep $GROUP)

sudo useradd -m -g $GROUP -u 2000 $USER
echo -e "1\n1" | sudo passwd $USER
# change primary group
sudo usermod -g $GROUP $USER
echo "Created user:" $(getent passwd | awk -F: '{ print $1}' | grep $USER)

# switch user to root
sudo su -

# create data directory
cd / && ls -la | grep 'data'
mkdir -p $DATA_DIR
chown $USER:$GROUP $DATA_DIR
chmod u+rwx,g+rwx,o+r-wx $DATA_DIR -R
cd / && ls -la | grep 'data'

# install docker & docker-compose
apt-get update -y
apt install -y docker.io
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# update docker permission
mkdir -p "$HOME/.docker"
usermod -aG docker $USER
chown "$USER":"$USER" /home/"$USER"/.docker -R
chmod g+rwx "$HOME/.docker" -R

# install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# switch user
sudo su - taquy
echo $(whoami)

# run infra & app
aws s3 cp s3://taquy-deploy/setup-infra.sh ./ && bash setup-infra.sh
aws s3 cp s3://taquy-deploy/setup-app.sh ./ && bash setup-app.sh
