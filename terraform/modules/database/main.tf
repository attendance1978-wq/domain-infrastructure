resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db"
  subnet_ids = var.subnet_ids
}

resource "random_password" "db" {
  length  = 24
  special = false
}

resource "aws_secretsmanager_secret" "db" {
  name = "${var.name}/db-credentials"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({ username = var.username, password = random_password.db.result })
}

resource "aws_db_instance" "this" {
  identifier              = "${var.name}-db"
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = 20
  max_allocated_storage   = 100
  storage_encrypted       = true
  db_name                 = "app"
  username                = var.username
  password                = random_password.db.result
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.security_group_ids
  multi_az                = var.multi_az
  backup_retention_period = 7
  deletion_protection     = var.multi_az
  skip_final_snapshot     = !var.multi_az
  final_snapshot_identifier = var.multi_az ? "${var.name}-final" : null
}
