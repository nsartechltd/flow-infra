resource "aws_cognito_user_pool" "flow_user_pool" {
  name = "flow-${var.environment}-user-pool"

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  auto_verified_attributes = ["email"]

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  username_attributes = ["email"]

  verification_message_template {
    email_subject = "Confirm Your Flow Account"
    email_message = "<h2>Verify your Flow account</h2><h3>Use the below code to verify your account</h3><code>{####}</code>"
  }

  schema {
    attribute_data_type      = "String"
    name                     = "given_name"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 50
      min_length = 1
    }
  }

  schema {
    attribute_data_type      = "String"
    name                     = "family_name"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 50
      min_length = 1
    }
  }

  schema {
    attribute_data_type      = "String"
    name                     = "organisation"
    developer_only_attribute = false
    mutable                  = false
    required                 = false
    string_attribute_constraints {
      max_length = 50
      min_length = 1
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "birthdate"
    mutable             = false
    required            = true
  }
}

resource "aws_cognito_user_pool_domain" "flow_cognito_domain" {
  domain       = "flow-app-user-pool"
  user_pool_id = aws_cognito_user_pool.flow_user_pool.id
}

resource "aws_cognito_user_pool_client" "flow_ui_client" {
  name         = "flow"
  user_pool_id = aws_cognito_user_pool.flow_user_pool.id

  prevent_user_existence_errors = "ENABLED"

  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}
