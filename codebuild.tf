data "aws_ssm_parameter" "codebuild_github_token" {
  name            = "/github/token"
  with_decryption = true
}

resource "aws_codebuild_source_credential" "github_authentication" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = data.aws_ssm_parameter.codebuild_github_token.value
}

resource "aws_codebuild_project" "flow_migrate" {
  name          = "${var.environment}-flow-migrate"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild_service_account.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/nsartechltd/flow-api"
    git_clone_depth = 1
    buildspec       = <<EOF
version: 0.2

env:
  variables:
    NODE_ENV: ${var.node_env}
  parameter-store:
    DB_USERNAME: /flow/rds/DB_USERNAME
    DB_PASSWORD: /flow/rds/DB_PASSWORD
    DB_HOST: /flow/rds/DB_HOST
    DB_DATABASE: /flow/rds/DB_DATABASE
    DATABASE_URL: /flow/rds/DB_URL

phases:
  install:
    runtime-versions:
      nodejs: 20.x
    commands:
      - npm ci

  build:
    commands:
      - npx prisma migrate deploy
EOF
  }

  vpc_config {
    vpc_id = aws_vpc.flow_vpc.id

    subnets = [
      aws_subnet.private_eu_west_2a.id,
      aws_subnet.private_eu_west_2b.id,
      aws_subnet.private_eu_west_2c.id,
    ]

    security_group_ids = [
      aws_vpc.flow_vpc.default_security_group_id
    ]
  }

  source_version = "master"
}