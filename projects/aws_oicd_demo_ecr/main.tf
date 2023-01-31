locals {
  circleci_project_id = "b181484f-e483-4028-97ba-6efaa8445c97"
}

variable "circleci_oidc_provider_base_url" {}
variable "circleci_oidc_org_id" {}
variable "circleci_oidc_provider_arn" {
  
}

resource "aws_iam_role_policy" "aws_oicd_demo_ecr_role_policy" {
  name = "oicd_demo_ecr_role_policy"
  role = aws_iam_role.aws_oicd_ecr_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "VisualEditor0",
        Effect = "Allow",
        Action = [
          "ecr:UntagResource",
          "ecr:CompleteLayerUpload",
          "ecr:TagResource",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage"
        ],
        Resource = "arn:aws:ecr:us-east-1:715930815444:repository/cci-demo-cr"
      },
      {
        Sid = "VisualEditor1",
        Effect = "Allow",
        Action = "ecr:GetAuthorizationToken",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "aws_oicd_ecr_role" {
  name = "oicd_demo_ecr_role"

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
