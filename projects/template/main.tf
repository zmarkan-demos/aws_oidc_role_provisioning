terraform {
  required_providers {
    circleci = {
        source = "mrolla/circleci"
        version = "~> 0.6"
      }
  }
}

# TODO: Replace PROJECT_NAME values with your real project name 
# TODO: Replace YOUR_CIRCLECI_PROJECT_ID with real project ID

locals {
    project_name = basename(abspath(path.module))
}

variable "circleci_oidc_provider_base_url" {}
variable "circleci_oidc_org_id" {}
variable "circleci_oidc_provider_arn" {}
variable "circleci_project_id" {}

resource "aws_iam_role_policy" "project_role_policy" {
  name = "${locals.project_name}-role_policy"
  role = aws_iam_role.project_role.id

  # TODO = replace with your policy JSON
  policy = jsonencode("YOUR_POLICY_JSON")
}

resource "aws_iam_role" "project_role" {
  name = "${locals.project_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = var.circleci_oidc_provider_arn
        },
        Condition = {
          StringLike = {
            "${var.circleci_oidc_provider_base_url}/${var.circleci_oidc_org_id}:sub" : "org/${var.circleci_oidc_org_id}/project/${local.circleci_project_id}/user/*"
          }
        }
      }
    ]
  })
}

resource "circleci_context" "arn_context" {
  name = "${locals.project_name}-aws-role-arn"
}

resource "circleci_context_environment_variable" "role_arn_var" {
  variable = "AWS_OICD_ARN_VAR"
  value = aws_iam_role.project_role.arn
  context_id = circleci_context.arn_context.id
}
