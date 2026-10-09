output "vpc_id"        { value = module.networking.vpc_id }
output "alb_dns_name"  { value = module.compute.alb_dns_name }
output "db_endpoint"   { value = module.database.endpoint }
output "zone_id"       { value = module.dns.zone_id }
output "nameservers"   { value = module.dns.nameservers }
