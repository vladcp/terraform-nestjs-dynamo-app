resource "aws_s3_bucket" "codepipeline_ecs_deploy" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.environment}-codepipeline-${var.project_name}"
  force_destroy = true
}