resource "aws_ssm_parameter" "cognito_user_pool_name" {
  name      = "/flow/cognito/USER_POOL_NAME"
  type      = "String"
  value     = aws_cognito_user_pool.flow_user_pool.name
  overwrite = true
}

resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name      = "/flow/cognito/USER_POOL_ID"
  type      = "String"
  value     = aws_cognito_user_pool.flow_user_pool.id
  overwrite = true
}

resource "aws_ssm_parameter" "DB_USERNAME" {
  name      = "/flow/rds/DB_USERNAME"
  type      = "String"
  value     = aws_rds_cluster.flow_rds.master_username
  overwrite = true
}
resource "aws_ssm_parameter" "DB_PASSWORD" {
  name        = "/flow/rds/DB_PASSWORD"
  description = "The parameter description"
  type        = "SecureString"
  value       = aws_rds_cluster.flow_rds.master_password
  overwrite   = true
}

resource "aws_ssm_parameter" "DB_DATABASE" {
  name      = "/flow/rds/DB_DATABASE"
  type      = "String"
  value     = aws_rds_cluster.flow_rds.database_name
  overwrite = true
}

resource "aws_ssm_parameter" "DB_HOST" {
  name      = "/flow/rds/DB_HOST"
  type      = "String"
  value     = aws_rds_cluster.flow_rds.endpoint
  overwrite = true
}

resource "aws_ssm_parameter" "DB_URL" {
  name      = "/flow/rds/DB_URL"
  type      = "String"
  value     = "postgresql://${aws_rds_cluster.flow_rds.master_username}:${aws_rds_cluster.flow_rds.master_password}@${aws_rds_cluster.flow_rds.endpoint}:5432/${aws_rds_cluster.flow_rds.database_name}"
  overwrite = true
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name      = "/flow/PRIVATE_SUBNET_IDS"
  type      = "StringList"
  value     = "${aws_subnet.private_eu_west_2a.id},${aws_subnet.private_eu_west_2b.id},${aws_subnet.private_eu_west_2c.id}"
  overwrite = true
}

resource "aws_ssm_parameter" "security_group_Id" {
  name      = "/flow/SECURITY_GROUP_ID"
  type      = "String"
  value     = aws_security_group.web_server.id
  overwrite = true
}