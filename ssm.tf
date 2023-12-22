resource "aws_ssm_parameter" "cognito_user_pool_name" {
  name      = "/flow/COGNITO_USER_POOL_NAME"
  type      = "String"
  value     = aws_cognito_user_pool.flow_user_pool.name
  overwrite = true
}