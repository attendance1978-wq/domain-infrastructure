#!/usr/bin/env bash
# Backup Terraform state, DB snapshot and configs
set -euo pipefail
ENV="${1:-production}"
TS="$(date +%Y%m%d-%H%M%S)"
OUT="backups/$ENV-$TS"
mkdir -p "$OUT"
aws s3 sync "s3://domain-infra-tfstate-$ENV" "$OUT/tfstate"
aws rds create-db-snapshot --db-instance-identifier "$ENV-domain-db" \
  --db-snapshot-identifier "$ENV-domain-$TS" >/dev/null
tar czf "$OUT/configs.tgz" ansible kubernetes dns monitoring
echo "backup written to $OUT"
