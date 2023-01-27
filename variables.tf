variable "circleci_oidc_provider_base_url" {
  type = string
  default = "oidc.circleci.com/org"
}

variable "circleci_oidc_org_id" {
  type = string
  sensitive = true
}

variable "circleci_api_token" {
  type = string
  sensitive = true
}

variable "aws_region" {
  default = "us-east-1"
  type = string
}