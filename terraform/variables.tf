variable "environment" {
  type        = string
  description = "Environment name (dev, staging, production)"
}
variable "region" {
  type    = string
  default = "us-east-1"
}
variable "domain_name" {
  type        = string
  description = "Primary domain, e.g. example.com"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "instance_type" {
  type    = string
  default = "t3.small"
}
variable "min_size" {
  type    = number
  default = 1
}
variable "max_size" {
  type    = number
  default = 3
}
variable "ami_id" {
  type        = string
  description = "AMI for compute instances"
}
variable "db_engine" {
  type    = string
  default = "postgres"
}
variable "db_engine_version" {
  type    = string
  default = "16.2"
}
variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "db_username" {
  type    = string
  default = "app"
}
variable "db_multi_az" {
  type    = bool
  default = false
}
