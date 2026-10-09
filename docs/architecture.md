# Architecture

Traffic flows Route53 -> ALB (public subnets) -> app instances / Kubernetes ingress (private subnets) -> RDS (private).

- **Networking**: one VPC per environment, 2 AZs, NAT for private egress.
- **Compute**: ASG behind ALB; optional Kubernetes workloads via Kustomize/Helm.
- **Data**: RDS PostgreSQL, credentials in Secrets Manager.
- **Observability**: Prometheus + Grafana + Loki.
- **Secrets**: SOPS with per-environment KMS keys.
