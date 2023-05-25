# Flow Infrastructure
Terraform codebase to create all the required infrastructure for Flow to run

## Quick Start

Using `init`, `plan` and `apply` below to init `state` and `plan` and `approve` changes once made.

### Init
```bash
AWS_PROFILE=PROFILE_NAME terraform init -backend-config="bucket=BUCKET_NAME" -backend-config="region=eu-west-2" -backend-config="key=state/FILE_NAME.tfstate"
```

### Plan
```bash
AWS_PROFILE=PROFILE_NAME terraform plan -var aws-profile="PROFILE_NAME" -var role="arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME" -var environment="ENVIRONMENT" -var node_env="NODE_ENV"
```

### Apply
```bash
AWS_PROFILE=PROFILE_NAME terraform apply -auto-approve -var aws-profile="PROFILE_NAME" -var role="arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME" -var environment="ENVIRONMENT" -var node_env="NODE_ENV"
```