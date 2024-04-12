resource "aws_cloudwatch_log_group" "ecs_deploy" {
  name = "${var.environment}-${var.project_name}"
}

resource "aws_cloudwatch_log_stream" "codebuild_ecs_deploy" {
  name           = "CodeBuild"
  log_group_name = aws_cloudwatch_log_group.ecs_deploy.name
}

resource "aws_cloudwatch_log_stream" "codepipeline_ecs_deploy" {
  name           = "CodePipeline"
  log_group_name = aws_cloudwatch_log_group.ecs_deploy.name
}

resource "aws_cloudwatch_log_resource_policy" "codebuild_ecs_deploy" {
  policy_document = data.aws_iam_policy_document.codebuild_ecs_deploy_log_publishing.json
  policy_name     = "codebuild-ecs-deploy-log-publishing-policy"
}