#!/bin/bash
set -e

# openssl req -new -text -passout pass:abcd -subj /CN=localhost -out server.req -keyout privkey.pem
# openssl rsa -in privkey.pem -passin pass:abcd -out server.key
# openssl req -x509 -in server.req -text -key server.key -out server.crt
# chmod 600 server.key
# test $(uname -s) = Linux && chown 70 server.key

#  "$(pwd)/server.crt:/var/lib/postgresql/server.crt:ro" -v 
#  "$(pwd)/server.key:/var/lib/postgresql/server.key:ro" postgres:12-alpine -c 
#  ssl=on -c 
#  ssl_cert_file=/var/lib/postgresql/server.crt 
#  -c ssl_key_file=/var/lib/postgresql/server.key

# sleep 1

# docker run --rm -it --link postgres postgres:12-alpine psql -h postgres -U postgres


psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER nextcloud UNENCRYPTED PASSWORD root1234;
    CREATE DATABASE nextcloud;
    GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud;
EOSQL