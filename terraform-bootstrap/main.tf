################################################################################
# This module is used to bootstrap the initial S3 bucket and dynamo table needed
# for terraform state storage!
################################################################################
variable "aws_region" {
  default = "eu-west-2"
}

output "state_bucket_name" {
  value = local.state_bucket_name
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  state_bucket_name = join("-", [
    data.aws_caller_identity.current.account_id,
    var.aws_region,
    "tf",
    "state"
  ])
}

################################################################################
# State bucket
resource "aws_s3_bucket" "terraform_state" {
  #checkov:skip=CKV_AWS_18
  #checkov:skip=CKV_AWS_144
  bucket = local.state_bucket_name
  lifecycle {
    prevent_destroy = true
  }
}

# resource "aws_s3_bucket_versioning" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

################################################################################
# Dynamo Lock Table
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = local.state_bucket_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}