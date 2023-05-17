terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.52"
      }
      circleci = {
        source = "mrolla/circleci"
        version = "~> 0.6"
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
}

provider "circleci" {
  api_token = var.circleci_api_token
  organization = "zmarkan-demos"
  vcs_type = "github"
}

resource "aws_iam_openid_connect_provider" "circleci_oidc_provider" {
  url = "https://${var.circleci_oidc_provider_base_url}/${var.circleci_oidc_org_id}"
  client_id_list = [
    var.circleci_oidc_org_id
  ]
  thumbprint_list = [ 
    "c510b3d1652c4d8b71b64911fb377d4d788c3a5a",
    "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
  ]
}
