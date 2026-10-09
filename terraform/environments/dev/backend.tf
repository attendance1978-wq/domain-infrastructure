terraform {
  backend "s3" {
    bucket         = "domain-infra-tfstate-dev"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "domain-infra-tflock-dev"
    encrypt        = true
  }
}
