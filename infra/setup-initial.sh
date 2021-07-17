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
# change primary group
sudo usermod -g $GROUP $USER
echo "Created user:" $(getent passwd | awk -F: '{ print $1}' | grep $USER)

# create data directory
sudo cd / && ls -la | grep 'data'
sudo mkdir -p $DATA_DIR
sudo chown $USER:$GROUP $DATA_DIR
sudo chmod u+rwx,g+rwx,o+r-wx $DATA_DIR -R
cd / && ls -la | grep 'data'

# install docker & docker-compose
sudo apt-get update -y
sudo apt install -y docker.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# update docker permission
sudo usermod -aG docker $USER
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R

# install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# run infra & app
aws s3 cp s3://taquy-deploy/setup-infra.sh ./ && bash setup-infra.sh

aws s3 cp s3://taquy-deploy/setup-app.sh ./ && bash setup-app.sh
