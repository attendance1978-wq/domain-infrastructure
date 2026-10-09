#!/usr/bin/env bash
# scripts/bootstrap.sh
# ---------------------------------------------------------------
# Purpose : Verify required tools + create Terraform backend
#           (S3 state bucket + DynamoDB lock table) per environment.
# Usage   : ./scripts/bootstrap.sh
# Env     : AWS_REGION (default: us-east-1)
# Deps    : terraform ansible kubectl helm sops aws
# ---------------------------------------------------------------

set -euo pipefail

# -------- configuration --------
REGION="${AWS_REGION:-us-east-1}"
ENVIRONMENTS=("dev" "staging" "production")
BUCKET_PREFIX="domain-infra-tfstate"
LOCK_PREFIX="domain-infra-tflock"
REQUIRED_TOOLS=(terraform ansible kubectl helm sops aws)

# -------- colors (disabled if not TTY) --------
if [ -t 1 ]; then
  C_RESET="\033[0m"
  C_RED="\033[31m"
  C_GREEN="\033[32m"
  C_YELLOW="\033[33m"
  C_BLUE="\033[34m"
  C_BOLD="\033[1m"
else
  C_RESET=""; C_RED=""; C_GREEN=""; C_YELLOW=""; C_BLUE=""; C_BOLD=""
fi

log_info()  { printf "${C_BLUE}▶${C_RESET} %s\n" "$*"; }
log_ok()    { printf "${C_GREEN}✔${C_RESET} %s\n" "$*"; }
log_warn()  { printf "${C_YELLOW}⚠${C_RESET} %s\n" "$*"; }
log_err()   { printf "${C_RED}✘${C_RESET} %s\n" "$*" >&2; }
log_title() { printf "\n${C_BOLD}%s${C_RESET}\n" "$*"; }

# -------- step 1: verify required tools --------
log_title "Step 1/4 — Verify required tools"

missing_tools=()
for t in "${REQUIRED_TOOLS[@]}"; do
  if command -v "$t" >/dev/null 2>&1; then
    log_ok "$t ($(command -v "$t"))"
  else
    log_err "$t — MISSING"
    missing_tools+=("$t")
  fi
done

if [ ${#missing_tools[@]} -gt 0 ]; then
  log_err "Missing required tools: ${missing_tools[*]}"
  echo ""
  echo "Install hints:"
  echo "  terraform : https://developer.hashicorp.com/terraform/install"
  echo "  ansible   : sudo apt install -y ansible"
  echo "  kubectl   : https://kubernetes.io/docs/tasks/tools/"
  echo "  helm      : curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash"
  echo "  sops      : https://github.com/getsops/sops/releases"
  echo "  aws       : https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
  exit 1
fi
log_ok "All required tools present"

# -------- step 2: verify AWS credentials --------
log_title "Step 2/4 — Verify AWS credentials"

if ! aws sts get-caller-identity >/dev/null 2>&1; then
  log_err "AWS credentials not configured or invalid."
  echo ""
  echo "Run:  aws configure"
  echo "Or export:  AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY / AWS_REGION"
  exit 1
fi

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
CALLER_ARN="$(aws sts get-caller-identity --query Arn     --output text)"
log_ok "AWS credentials OK"
echo "    account : $ACCOUNT_ID"
echo "    identity: $CALLER_ARN"
echo "    region  : $REGION"

# -------- step 3: create backend resources --------
log_title "Step 3/4 — Provision Terraform backend"

for env in "${ENVIRONMENTS[@]}"; do
  BUCKET="${BUCKET_PREFIX}-${env}"
  LOCK="${LOCK_PREFIX}-${env}"

  echo ""
  log_info "[$env] bucket: $BUCKET | lock-table: $LOCK"

  # --- S3 state bucket ---
  if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
    log_ok "  bucket already exists"
  else
    log_info "  creating bucket..."

    if [ "$REGION" = "us-east-1" ]; then
      aws s3api create-bucket \
        --bucket "$BUCKET" \
        --region "$REGION" >/dev/null
    else
      aws s3api create-bucket \
        --bucket "$BUCKET" \
        --region "$REGION" \
        --create-bucket-configuration LocationConstraint="$REGION" >/dev/null
    fi

    aws s3api put-bucket-versioning \
      --bucket "$BUCKET" \
      --versioning-configuration Status=Enabled

    aws s3api put-bucket-encryption \
      --bucket "$BUCKET" \
      --server-side-encryption-configuration \
      '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"},"BucketKeyEnabled":true}]}'

    aws s3api put-public-access-block \
      --bucket "$BUCKET" \
      --public-access-block-configuration \
      "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

    log_ok "  bucket created (versioned, encrypted, private)"
  fi

  # --- DynamoDB lock table ---
  if aws dynamodb describe-table --table-name "$LOCK" >/dev/null 2>&1; then
    log_ok "  lock table already exists"
  else
    log_info "  creating lock table..."
    aws dynamodb create-table \
      --table-name "$LOCK" \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --billing-mode PAY_PER_REQUEST >/dev/null

    # wait until table is ACTIVE (max ~60s)
    aws dynamodb wait table-exists --table-name "$LOCK"
    log_ok "  lock table created and ACTIVE"
  fi
done

# -------- step 4: summary --------
log_title "Step 4/4 — Summary"

echo ""
echo "S3 state buckets:"
aws s3 ls | grep "$BUCKET_PREFIX" || log_warn "no buckets found"

echo ""
echo "DynamoDB lock tables:"
aws dynamodb list-tables --output text --query 'TableNames' \
  | tr '\t' '\n' | grep "$LOCK_PREFIX" || log_warn "no lock tables found"

echo ""
log_ok "bootstrap complete"
echo ""
echo "Next steps:"
echo "  1. Review terraform/environments/dev/backend.tf"
echo "  2. make init ENV=dev"
echo "  3. make plan ENV=dev"