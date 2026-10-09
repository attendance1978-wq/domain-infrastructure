# domain-infrastructure

Infrastructure as Code for a domain-hosted application: Terraform (AWS), Ansible, Kubernetes (Kustomize + Helm), Docker, DNS, TLS, monitoring and SOPS-encrypted secrets.

## Quick start
```bash
make bootstrap            # install tooling check + create state bucket
cp terraform/terraform.tfvars.example terraform/environments/dev/terraform.tfvars
make plan ENV=dev
make apply ENV=dev
make deploy ENV=dev       # ansible + k8s
```

## Layout
| Path | Purpose |
|------|---------|
| terraform/ | VPC, compute, database, security, DNS modules and per-env roots |
| ansible/ | Host configuration (nginx, docker, monitoring) |
| kubernetes/ | Kustomize base/overlays and Helm chart |
| docker/ | Image build and local compose stack |
| dns/ | Zone files and structured records |
| ssl/ | Cert scripts (certs are git-ignored) |
| monitoring/ | Prometheus, Grafana, Loki |
| secrets/ | SOPS-encrypted secrets |
| docs/ | Architecture, runbooks, ADRs |
| tests/ | Terratest, Bats, Trivy |

## Requirements
terraform >= 1.5, ansible >= 2.15, kubectl, kustomize, helm, sops, docker, aws cli, go (for terratest), bats.
# domain-infrastructure
# domain-infrastructure
