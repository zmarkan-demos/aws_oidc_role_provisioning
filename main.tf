terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.52"
      }
    }

    required_version = ">= 1.3.7"

    backend "remote" {
      organization = "circleci_oicd_demo_org"
      workspaces {
      name = "infra_provisioning"
    }
  }
}


provider "aws" {
    region = var.aws_region
    default_tags {
      tags = {
        Project = "circleci-aws-oidc-devrel-demo-zmarkan"
        Owner = "zmarkan"
      }
    }
    profile = "CIRCLECI-OIDC-PROVISIONING-PROFILE"
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

output "circleci_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.circleci_oidc_provider.arn
}