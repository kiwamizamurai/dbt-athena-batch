# ----------------------------------------------
# AWS Configuration
# ----------------------------------------------
provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Name = "${var.project_name}"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}


# ----------------------------------------------
# Terraform Versions
# ----------------------------------------------
terraform {
  required_version = "1.2.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }

  # backend "s3" {
  #   bucket  = "${var.project_name}-state"
  #   region  = data.aws_region.current. name
  #   key     = "terraform.tfstate"
  #   encrypt = true
  # }
}
