#!/usr/bin/env bash
# Renew certificates via Let's Encrypt (certbot)
set -euo pipefail
DOMAIN="${1:-example.com}"
EMAIL="${2:-admin@example.com}"
certbot certonly --non-interactive --agree-tos --email "$EMAIL" \
  --dns-route53 -d "$DOMAIN" -d "*.$DOMAIN" --keep-until-expiring
certbot renew --quiet
echo "Certificates renewed for $DOMAIN"
