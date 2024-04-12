variable "environment" {
  description = "Deployed environment identifier"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  default = "eu-west-2"
}

variable "project_name" {
  description = "Project Name Identifier"
  default     = "ecs-deploy-nestjs"
  type        = string
}
################################################################################
# Codepipeline
################################################################################

variable "terraform_version" {
  description = "Terraform version to use in codepipeline"
  type        = string
  default     = "1.3.0"
}
################################################################################
# Codebuild
################################################################################

variable "codebuild_image" {
  description = "CodeBuild image"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
}

variable "codebuild_tf_image" {
  description = "Terraform image to be used in CodeBuild"
  type = string
  default = "hashicorp/terraform:latest"
}

variable "codebuild_node_size" {
  default = "BUILD_GENERAL1_SMALL"
}
################################################################################
# Github
################################################################################

variable "gh_branch" {
  description = "Github branch"
  type        = string
  default     = "main"
}

variable "gh_org_name" {
  description = "Github organisation name"
  type        = string
  default     = "vladcp"
}

variable "tf_gh_repo_name" {
  description = "Github Terraform repository name"
  type        = string
  default     = "terraform-nestjs-dynamo-app"
}

variable "app_gh_repo_name" {
  description = "Github Terraform repository name"
  type        = string
  default     = "nestjs-dynamo-app"
}