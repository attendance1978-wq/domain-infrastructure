# Incident Response

1. Acknowledge the alert and open an incident channel.
2. Check Grafana "Domain Overview" and `scripts/healthcheck.sh <env>`.
3. Identify recent changes (`git log`, CI runs).
4. Mitigate: roll back (`kubectl rollout undo`), scale up, or fail over.
5. Communicate status every 30 minutes.
6. Write a post-mortem within 5 working days.
