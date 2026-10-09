# Disaster Recovery

1. Declare DR and assign an incident commander.
2. Restore the latest RDS snapshot to the DR region.
3. Re-apply Terraform with the DR region variables.
4. Update Route53 records / health checks to the DR load balancer.
5. Run `scripts/healthcheck.sh production`.
6. Target RTO: 1h, RPO: 15m.
