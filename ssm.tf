resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name      = "/flow/COGNITO_USER_POOL_ID"
  type      = "String"
  value     = aws_cognito_user_pool.flow_user_pool.id
  overwrite = true
}