# DocumentDB (MongoDB-compatible) Database

# DB Subnet Group
resource "aws_docdb_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-docdb-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${var.project_name}-${var.environment}-docdb-subnet-group"
  }
}

# DocumentDB Cluster Parameter Group
resource "aws_docdb_cluster_parameter_group" "main" {
  family = "docdb5.0"
  name   = "${var.project_name}-${var.environment}-docdb-params"

  parameter {
    name  = "tls"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-docdb-params"
  }
}

# Generate random password for DocumentDB
resource "random_password" "docdb_password" {
  length  = 16
  special = true
}

# DocumentDB Cluster
resource "aws_docdb_cluster" "main" {
  cluster_identifier      = "${var.project_name}-${var.environment}-docdb"
  engine                  = "docdb"
  master_username         = "hamradio"
  master_password         = random_password.docdb_password.result
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  storage_encrypted       = true

  db_subnet_group_name            = aws_docdb_subnet_group.main.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.main.name
  vpc_security_group_ids          = [aws_security_group.database.id]

  tags = {
    Name = "${var.project_name}-${var.environment}-docdb"
  }
}

# DocumentDB Cluster Instance
resource "aws_docdb_cluster_instance" "main" {
  count              = 1
  identifier         = "${var.project_name}-${var.environment}-docdb-${count.index}"
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class     = var.db_instance_class

  tags = {
    Name = "${var.project_name}-${var.environment}-docdb-${count.index}"
  }
}

# Store database password in AWS Systems Manager Parameter Store
resource "aws_ssm_parameter" "docdb_password" {
  name  = "/${var.project_name}/${var.environment}/docdb/password"
  type  = "SecureString"
  value = random_password.docdb_password.result

  tags = {
    Name = "${var.project_name}-${var.environment}-docdb-password"
  }
}