#!/bin/bash
domains=(taquy.com portainer.taquy.com cockpit.taquy.com cms.taquy.com api.taquy.com es.taquy.com kibana.taquy.com redis.taquy.com mongo.taquy.com jenkins.taquy.com octopus.taquy.com mssql.taquy.com)
rsa_key_size=4096
data_path="/data/certbot/ssl"
email="taquy.pb@gmail.com"
staging=1
docker_cp_file=infra.yml

echo "### Downloading recommended TLS parameters ..."
curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf >"$data_path/options-ssl-nginx.conf"
curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem >"$data_path/ssl-dhparams.pem"
echo

echo "### Creating dummy certificate for $domains ..."
path="/etc/letsencrypt/live/$domains"
mkdir -p "$data_path/live/$domains"
docker-compose -f $docker_cp_file run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:$rsa_key_size -days 1\
    -keyout '$path/privkey.pem' \
    -out '$path/fullchain.pem' \
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

echo "### Reloading nginx ..."
docker-compose -f $docker_cp_file exec nginx nginx -s reload
