#!/usr/bin/env bash
# Deploy pipeline: terraform plan -> apply -> ansible -> k8s -> healthcheck
set -euo pipefail
ENV="${1:-dev}"
cd "$(dirname "$0")/.."
TF="terraform/environments/$ENV"
terraform -chdir="$TF" init -input=false
terraform -chdir="$TF" plan -input=false -out=tfplan
if [[ "$ENV" == "production" ]]; then
  read -r -p "Apply to PRODUCTION? (yes/no) " ans
  [[ "$ans" == "yes" ]] || exit 1
fi
terraform -chdir="$TF" apply -input=false tfplan
ansible-playbook -i "ansible/inventory/$ENV.ini" ansible/playbooks/site.yml
kubectl apply -k "kubernetes/overlays/$ENV"
./scripts/healthcheck.sh "$ENV"
