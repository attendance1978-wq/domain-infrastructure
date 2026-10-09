terraform {
  backend "s3" {
    bucket         = "domain-infra-tfstate-staging"
    key            = "staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "domain-infra-tflock-staging"
    encrypt        = true
  }
}
