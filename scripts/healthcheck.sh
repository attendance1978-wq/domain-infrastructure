#!/usr/bin/env bash
# Post-deploy health verification
set -euo pipefail
ENV="${1:-dev}"
case "$ENV" in
  production) HOST="example.com" ;;
  *) HOST="$ENV.example.com" ;;
esac
for i in {1..10}; do
  code=$(curl -s -o /dev/null -w '%{http_code}' "https://$HOST/healthz" || true)
  if [[ "$code" == "200" ]]; then echo "healthy: $HOST"; exit 0; fi
  echo "attempt $i: got $code, retrying..."; sleep 10
done
echo "unhealthy: $HOST" >&2
exit 1
