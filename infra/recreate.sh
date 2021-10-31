docker-compose down
docker system prune -f
docker container prune -f
docker volume prune -f

rm -rf /data/*
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/portainer portainer-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/jenkins/home jenkins-home-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/jenkins/cache jenkins-cache-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/jenkins/logs jenkins-logs-vol

docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/octopus/repository octopus-repository-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/octopus/artifacts octopus-artifacts-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/octopus/taskLogs octopus-taskLogs-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/octopus/cache octopus-cache-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/octopus/import octopus-import-vol

docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/mssql mssql-vol

docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/nginx/logs nginx-logs-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/nginx/conf nginx-conf-vol

docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/certbot/logs certbot-logs-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/certbot/conf certbot-conf-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/certbot/www certbot-www-vol

docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/backup/logs backup-logs-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/backup/archives backup-archives-vol

mkdir -p /data/traefik/ssl
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/traefik/ssl traefik-ssl-vol

mkdir -p /data/infra-redis
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/infra-redis infra-redis-vol

mkdir -p /data/authelia/source /data/authelia/config /data/authelia/mysql /data/authelia/redis
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/authelia/source authelia-source-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/authelia/config authelia-config-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/authelia/mysql authelia-mysql-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/authelia/redis authelia-redis-vol

mkdir -p /data/heimdall
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/heimdall heimdall-vol

mkdir -p /data/pihole /data/pihole/etc /data/pihole/dns
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/pihole/etc pihole-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/pihole/dns pihole-dns-vol

docker volume create --driver local --opt o=bind --opt type=none --opt device=/home/taquy/.aws aws-credentials-vol

mkdir -p /data/portainer
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/portainer portainer-vol

mkdir -p /data/ldap/source /data/ldap/slapd /data/ldap/certs
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/ldap/source ldap-source-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/ldap/slapd ldap-slapd-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/ldap/certs ldap-certs-vol

mkdir -p /data/owncloud/source /data/owncloud/mysql /data/owncloud/redis
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/owncloud/source owncloud-source-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/owncloud/mysql owncloud-mysql-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/owncloud/redis owncloud-redis-vol

mkdir -p /data/storage/postgres
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/storage/postgres storage-postgres
# create ssl certs
## https://www.digicert.com/kb/ssl-support/openssl-quick-reference-guide.htm
## https://gist.github.com/fntlnz/cf14feb5a46b2eda428e000157447309
mkdir -p setup-postgres && rm -rf *
# 1. generate root CA
openssl genrsa -out root.key 4096
openssl req -x509 -new -nodes -key root.key -sha256 -days 1024 -out root.crt \
  -subj '/C=VN/ST=Hanoi/L=Hanoi/O=taquy/OU=IT/CN=taquy.dev/emailAddress=admin@taquy.dev'

# 2. generate signing
mkdir -p setup-postgres && cd setup-postgres && rm -rf *
openssl req -nodes -newkey rsa:2048 -keyout postgres.key -out postgres.csr \
  -subj '/C=VN/ST=Hanoi/L=Hanoi/O=taquy/OU=IT/CN=postgres.taquy.dev/emailAddress=admin@taquy.dev'
openssl req -in postgres.crt -noout -text

# 3. generate server
openssl x509 -req -in postgres.csr -CA root.crt -CAkey root.key -CAcreateserial -out postgres.crt -days 500 -sha256
openssl x509 -in postgres.crt -text -noout
chmod 400 * && cd ..
# chown postgres.postgres setup-postgres/server.key



mkdir -p /data/storage/redis
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/storage/redis storage-redis

mkdir -p /data/storage/nextcloud
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/storage/nextcloud nextcloud-vol

mkdir -p /data/rocketchat/source /data/rocketchat/mongo /data/rocketchat/hubot
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/rocketchat/source rocketchat-source-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/rocketchat/mongo rocketchat-mongo-vol
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/rocketchat/hubot rocketchat-hubot-vol

mkdir -p /data/rocketchat/source /data/openvpn
docker volume create --driver local --opt o=bind --opt type=none --opt device=/data/openvpn openvpn-vol

docker network create -d bridge taquy-traefik
docker-compose up -d