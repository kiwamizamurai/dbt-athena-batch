plugin "aws" {
  enabled = true
  version = "0.15.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule  "aws_secretsmanager_secret_version_invalid_secret_string" {
  enabled = false
}
