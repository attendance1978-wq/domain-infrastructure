variable "ami_id" { type = string }

module "infra" {
  source = "../.."

  environment       = "staging"
  region            = "us-east-1"
  domain_name       = "staging.example.com"
  vpc_cidr          = "10.20.0.0/16"
  ami_id            = var.ami_id
  instance_type     = "t3.medium"
  min_size          = 2
  max_size          = 4
  db_instance_class = "db.t3.small"
  db_multi_az       = false
}

output "alb_dns_name" { value = module.infra.alb_dns_name }
output "db_endpoint"  { value = module.infra.db_endpoint }
