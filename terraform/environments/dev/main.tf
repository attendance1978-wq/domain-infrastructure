variable "ami_id" { type = string }

module "infra" {
  source = "../.."

  environment       = "dev"
  region            = "us-east-1"
  domain_name       = "dev.example.com"
  vpc_cidr          = "10.10.0.0/16"
  ami_id            = var.ami_id
  instance_type     = "t3.small"
  min_size          = 1
  max_size          = 2
  db_instance_class = "db.t3.micro"
  db_multi_az       = false
}

output "alb_dns_name" { value = module.infra.alb_dns_name }
output "db_endpoint"  { value = module.infra.db_endpoint }
