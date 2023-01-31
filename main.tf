terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.52"
      }
    }

    required_version = ">= 1.3.7"
}

provider "aws" {
    region = var.aws_region
    default_tags {
      tags = {
        Project = "circleci-aws-oidc-devrel-demo-zmarkan"
        Owner = "zmarkan"
      }
    }

}

module "aws_oicd_demo_ecr_project" {
  source = "./projects/aws_oicd_demo_ecr"
  circleci_oidc_provider_base_url = var.circleci_oidc_provider_base_url
  circleci_oidc_org_id = var.circleci_oidc_org_id
  circleci_oidc_provider_arn = aws_iam_openid_connect_provider.circleci_oidc_provider.arn
}

variable "circleci_oidc_provider_base_url" {
  type = string
  default = "oidc.circleci.com/org"
}

variable "circleci_oidc_org_id" {
  type = string
  sensitive = true
}

variable "aws_region" {
  default = "us-east-1"
  type = string
}

resource "aws_iam_openid_connect_provider" "circleci_oidc_provider" {
  url = "https://${var.circleci_oidc_provider_base_url}/${var.circleci_oidc_org_id}"
  client_id_list = [
    var.circleci_oidc_org_id
  ]
  thumbprint_list = [ 
    "C510B3D1652C4D8B71B64911FB377D4D788C3A5A" 
  ]
}

# resource "aws_iam_role_policy" "my_role_policy" {
#     provider = circleci_oidc_provider.arn
#     name = "test_policy"
#     role = aws_iam_role.test_role.id

#     policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:Describe*",
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

# resource "aws_iam_role" "test_role" {
#   name = "test_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })
# }
  
