################################################################################
# Codepipeline
################################################################################

resource "aws_iam_role" "codepipeline_ecs_deploy" {
  name               = "codepipeline-${var.environment}-${var.project_name}"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}

resource "aws_iam_role_policy" "codepipeline_ecs_deploy" {
  role   = aws_iam_role.codepipeline_ecs_deploy.name
  policy = data.aws_iam_policy_document.codepipeline_ecs_deploy.json
}

resource "aws_iam_role_policy" "codepipeline_ecs_deploy_codebuild_perms" {
  role   = aws_iam_role.codepipeline_ecs_deploy.name
  policy = data.aws_iam_policy_document.codepipeline_ecs_deploy_codebuild.json
}
################################################################################
# Codebuild
################################################################################

resource "aws_iam_role" "codebuild_ecs_deploy" {
  name                = "codebuild-${var.environment}-${var.project_name}"
  assume_role_policy  = data.aws_iam_policy_document.codebuild_assume_role.json
  managed_policy_arns = [data.aws_iam_policy.admin_fullaccess.arn]
}

resource "aws_iam_role_policy" "codepipeline_ecs_deploy_codebuild" {
  role   = aws_iam_role.codebuild_ecs_deploy.name
  policy = data.aws_iam_policy_document.codebuild_ecs_deploy.json
}