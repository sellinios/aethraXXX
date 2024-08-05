#!/bin/bash

domains=(kairos.gr www.kairos.gr api.kairos.gr admin.kairos.gr)
rsa_key_size=4096
data_path="./certbot"
email="lefteris.broker@gmail.com" # Change to your email
staging=0 # Set to 1 if you're testing your setup to avoid hitting request limits

if [ -d "$data_path" ]; then
  read -p "Existing data found for ${domains[*]}. Continue and replace existing certificates? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    exit
  fi
fi

for domain in "${domains[@]}"; do
  mkdir -p "$data_path/conf/live/$domain"
done

staging_arg=""
if [ $staging != "0" ]; then
  staging_arg="--staging"
fi

for domain in "${domains[@]}"; do
  docker run --rm -v "$data_path/conf:/etc/letsencrypt" -v "$data_path/www:/var/www/certbot" \
    certbot/certbot \
    certonly --webroot -w /var/www/certbot \
      $staging_arg \
      --email $email \
      -d $domain \
      --rsa-key-size $rsa_key_size \
      --agree-tos \
      --force-renewal \
      --non-interactive
done

echo "### Reloading nginx ..."
docker service update --force aethra_nginx-frontend
docker service update --force aethra_nginx-backend