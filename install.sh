#!/bin/bash

DOMAIN=$1

if ! [ -n "$1" ]; then
    echo 'Error: domain name as param is needed' >&2
    exit 1
fi

[ -f .env ] && rm .env

echo DOMAIN=${DOMAIN} >> .env
echo EMAIL=admin@${DOMAIN} >> .env

# initiate config
docker-compose -f ./docker-compose.initiate.yaml up -d nginx
docker-compose -f ./docker-compose.initiate.yaml up certbot
docker-compose -f ./docker-compose.initiate.yaml down

 
# configurations for let's encrypt
curl -L --create-dirs -o ./data/letsencrypt/options-ssl-nginx.conf https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf
openssl dhparam -out ./data/letsencrypt/ssl-dhparams.pem 2048
