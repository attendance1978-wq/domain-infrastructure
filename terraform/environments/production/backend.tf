terraform {
  backend "s3" {
    bucket         = "domain-infra-tfstate-production"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "domain-infra-tflock-production"
    encrypt        = true
  }
}
