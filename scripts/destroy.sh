#!/usr/bin/env bash
# Tear down infrastructure for an environment (requires typed confirmation)
set -euo pipefail
ENV="${1:?usage: destroy.sh <env>}"
read -r -p "Type the environment name '$ENV' to confirm destroy: " ans
[[ "$ans" == "$ENV" ]] || { echo "aborted"; exit 1; }
terraform -chdir="terraform/environments/$ENV" destroy
