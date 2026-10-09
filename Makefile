ENV ?= dev
TF_DIR = terraform/environments/$(ENV)

.PHONY: bootstrap init plan apply destroy deploy test lint scan

bootstrap:
	./scripts/bootstrap.sh

init:
	terraform -chdir=$(TF_DIR) init

plan: init
	terraform -chdir=$(TF_DIR) plan -var-file=terraform.tfvars -out=tfplan

apply:
	terraform -chdir=$(TF_DIR) apply tfplan

destroy:
	./scripts/destroy.sh $(ENV)

deploy:
	./scripts/deploy.sh $(ENV)

lint:
	terraform fmt -check -recursive terraform
	ansible-lint ansible/playbooks

scan:
	trivy config --config tests/security/scanning/trivy-config.yaml .

test:
	bats tests/integration
	cd tests/terratest && go test -v ./...
