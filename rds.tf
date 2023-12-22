provider "postgresql" {
  host     = aws_rds_cluster.flow_rds.endpoint
  port     = 5432
  database = "flow"
  username = aws_ssm_parameter.DB_USERNAME.value
  password = aws_ssm_parameter.DB_PASSWORD.value
}

resource "random_password" "flow_database_password" {
  length  = 16
  special = false
  lifecycle {
    ignore_changes = all
  }
}

locals {
  timestamp       = timestamp()
  timestamp_short = replace("${local.timestamp}", "/[- TZ:]/", "")
}

resource "aws_rds_cluster" "flow_rds" {
  cluster_identifier      = "flow-${var.environment}-rds"
  engine                  = "aurora-postgresql"
  engine_version          = "14.8"
  engine_mode             = "provisioned"
  database_name           = "flow"
  master_username         = "flow_user"
  master_password         = random_password.flow_database_password.result
  backup_retention_period = 7

  # notes time of creation of rds.tf file
  final_snapshot_identifier = "flow-${var.environment}-rds-${local.timestamp_short}"

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.flow_subnet_group.id

  serverlessv2_scaling_configuration {
    max_capacity             = 1
    min_capacity             = 0.5
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "flow-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_rds_cluster_instance" "flow_rds_instance" {
  cluster_identifier = aws_rds_cluster.flow_rds.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.flow_rds.engine
  engine_version     = aws_rds_cluster.flow_rds.engine_version
}