#!/bin/bash

domains=(kairos.gr www.kairos.gr)
rsa_key_size=4096
data_path="./certbot"
email="lefteris.broker@gmail.com" # Change to your email
staging=1 # Set to 1 if you're testing your setup to avoid hitting request limits

if [ -d "$data_path" ]; then
  read -p "Existing data found for $domains. Continue and replace existing certificate? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    exit
  fi
fi

mkdir -p "$data_path/conf/live/$domains"
docker run --rm -v "$data_path/conf:/etc/letsencrypt" -v "$data_path/www:/var/www/certbot" \
  certbot/certbot \
  certonly --webroot -w /var/www/certbot \
    $staging_arg \
    --email $email \
    -d ${domains[0]} -d ${domains[1]} \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal \
    --non-interactive

echo "### Reloading nginx ..."
docker service update --force aethra_nginx