variable "ami_id" { type = string }

module "infra" {
  source = "../.."

  environment       = "production"
  region            = "us-east-1"
  domain_name       = "example.com"
  vpc_cidr          = "10.30.0.0/16"
  ami_id            = var.ami_id
  instance_type     = "m5.large"
  min_size          = 3
  max_size          = 10
  db_instance_class = "db.m5.large"
  db_multi_az       = true
}

output "alb_dns_name" { value = module.infra.alb_dns_name }
output "db_endpoint"  { value = module.infra.db_endpoint }
