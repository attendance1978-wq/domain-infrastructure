# networking module
Creates a VPC with public/private subnets across AZs, an Internet Gateway, a NAT Gateway and route tables.

Inputs: `name`, `vpc_cidr`, `azs`. Outputs: `vpc_id`, `public_subnet_ids`, `private_subnet_ids`.
