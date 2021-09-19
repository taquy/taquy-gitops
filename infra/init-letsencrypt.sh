#!/bin/bash

domains=("taquy.dev" "portainer.taquy.dev" "cockpit.taquy.dev" "cms.taquy.dev" "api.taquy.dev" "es.taquy.dev" "kibana.taquy.dev" "redis.taquy.dev" "mongo.taquy.dev" "jenkins.taquy.dev" "octopus.taquy.dev" "mssql.taquy.dev")
rsa_key_size=4096
data_path="/data/certbot/ssl"
email="taquy.pb@gmail.com"
staging=1
docker_cp_file=infra.yml

EXTERNAL_PATH="$data_path/live/$domains"
INTERNAL_PATH="/etc/letsencrypt/live/$domains"
mkdir -p $EXTERNAL_PATH

echo "### Downloading recommended TLS parameters ..."
curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf >"$data_path/options-ssl-nginx.conf"
curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem >"$data_path/ssl-dhparams.pem"
echo

echo "### Creating dummy certificate for $domains ..."

docker-compose -f $docker_cp_file run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:$rsa_key_size -days 1\
    -keyout '$INTERNAL_PATH/privkey.pem' \
    -out '$INTERNAL_PATH/fullchain.pem' \
    -subj '/CN=localhost'" certbot
echo

echo "### Starting nginx ..."
docker-compose -f $docker_cp_file up --force-recreate -d nginx
echo

echo "### Deleting dummy certificate for $domains ..."
docker-compose -f $docker_cp_file run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/$domains && \
  rm -Rf /etc/letsencrypt/archive/$domains && \
  rm -Rf /etc/letsencrypt/renewal/$domains.conf" certbot
echo

echo "### Requesting Let's Encrypt certificate for $domains ..."
domain_args=""
for domain in "${domains[@]}"; do
	domain_args="$domain_args -d $domain"
done

case "$email" in
"") email_arg="--register-unsafely-without-email" ;;
*) email_arg="--email $email" ;;
esac

if [ $staging != "0" ]; then staging_arg="--staging"; fi

docker-compose -f $docker_cp_file run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/html \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal" certbot
echo

# certbot certonly --webroot -w /var/www/html     --staging     --email taquy.pb@gmail.com      -d taquy.dev -d portainer.taquy.dev -d cockpit.taquy.dev -d cms.taquy.dev -d api.taquy.dev -d es.taquy.dev -d kibana.taquy.dev -d redis.taquy.dev -d mongo.taquy.dev -d jenkins.taquy.dev -d octopus.taquy.dev -d mssql.taquy.dev     --rsa-key-size 4096     --agree-tos     --force-renewal

echo "### Reloading nginx ..."
docker-compose -f $docker_cp_file exec nginx nginx -s reload
