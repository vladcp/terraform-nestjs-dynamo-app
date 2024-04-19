terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.45.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}
provider "aws" {
  region = var.aws_region
} 