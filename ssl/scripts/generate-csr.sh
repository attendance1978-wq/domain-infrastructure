#!/usr/bin/env bash
# Generate a private key and CSR
set -euo pipefail
DOMAIN="${1:?usage: generate-csr.sh <domain>}"
OUT="$(dirname "$0")/../csr"
openssl req -new -newkey rsa:4096 -nodes \
  -keyout "$OUT/$DOMAIN.key" -out "$OUT/$DOMAIN.csr" \
  -subj "/CN=$DOMAIN"
chmod 600 "$OUT/$DOMAIN.key"
echo "CSR written to $OUT/$DOMAIN.csr"
