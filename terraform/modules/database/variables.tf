variable "name"               { type = string }
variable "engine"             { type = string }
variable "engine_version"     { type = string }
variable "instance_class"     { type = string }
variable "username"           { type = string }
variable "multi_az"           { type = bool }
variable "subnet_ids"         { type = list(string) }
variable "security_group_ids" { type = list(string) }
