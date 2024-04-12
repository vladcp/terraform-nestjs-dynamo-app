data "aws_caller_identity" "current" {}

data "aws_codestarconnections_connection" "github_docker_build" {
  name = "${var.project_name}-github"
}

data "aws_iam_policy" "admin_fullaccess" {
  name = "AdministratorAccess"
}

data "aws_iam_policy_document" "codebuild_ecs_deploy_log_publishing" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["arn:aws:logs:*"]

    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"] 
  }
}

data "aws_iam_policy_document" "codepipeline_ecs_deploy_codebuild" {
  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = [
      aws_codebuild_project.github_ecs_deploy_base.arn,
      aws_codebuild_project.github_ecs_deploy_app.arn
    ]
  }
}

data "aws_iam_policy_document" "codepipeline_ecs_deploy" {
  statement {
    effect = "Allow"

    actions = [
      "codestar-connections:UseConnection"
    ]

    resources = [
      data.aws_codestarconnections_connection.github_docker_build.arn
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:Put*",
    ]

    resources = [
      aws_s3_bucket.codepipeline_ecs_deploy.arn,
      "${aws_s3_bucket.codepipeline_ecs_deploy.arn}/*",
    ]
  }
}
################################################################################
# Codebuild
################################################################################
data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codebuild_ecs_deploy" {
  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = [
      aws_codebuild_project.github_ecs_deploy_base.arn,
      aws_codebuild_project.github_ecs_deploy_app.arn
    ]
  }
}