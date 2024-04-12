terraform {
  # required_version = "~> 1.5.5"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region 

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      CreatedBy   = "Terraform"
    }
  }
}