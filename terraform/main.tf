provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project     = "domain-infrastructure"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

module "networking" {
  source      = "./modules/networking"
  name        = "${var.environment}-domain"
  vpc_cidr    = var.vpc_cidr
  azs         = var.azs
}

module "security" {
  source   = "./modules/security"
  name     = "${var.environment}-domain"
  vpc_id   = module.networking.vpc_id
  vpc_cidr = var.vpc_cidr
}

module "compute" {
  source             = "./modules/compute"
  name               = "${var.environment}-domain"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  min_size           = var.min_size
  max_size           = var.max_size
  subnet_ids         = module.networking.private_subnet_ids
  public_subnet_ids  = module.networking.public_subnet_ids
  vpc_id             = module.networking.vpc_id
  security_group_ids = [module.security.app_sg_id]
  alb_sg_id          = module.security.alb_sg_id
  instance_profile   = module.security.instance_profile_name
}

module "database" {
  source             = "./modules/database"
  name               = "${var.environment}-domain"
  engine             = var.db_engine
  engine_version     = var.db_engine_version
  instance_class     = var.db_instance_class
  username           = var.db_username
  multi_az           = var.db_multi_az
  subnet_ids         = module.networking.private_subnet_ids
  security_group_ids = [module.security.db_sg_id]
}

module "dns" {
  source       = "./modules/dns"
  domain_name  = var.domain_name
  alb_dns_name = module.compute.alb_dns_name
  alb_zone_id  = module.compute.alb_zone_id
}
