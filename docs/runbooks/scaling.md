# Scaling

- ASG: adjust `min_size`/`max_size` in the env `main.tf`, then `make plan apply ENV=<env>`.
- Kubernetes: edit replicas/HPA in `kubernetes/overlays/<env>`, then `kubectl apply -k`.
- Database: change `db_instance_class`; apply during a maintenance window.
