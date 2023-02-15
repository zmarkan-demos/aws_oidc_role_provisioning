# TODO: Add new modules below by using the template
module "aws_oicd_demo_ecr_project" {
  source = "./projects/aws_oicd_demo_ecr"
  circleci_project_id = "6fb58098-00af-454d-994f-67833560caf2"
  circleci_oidc_provider_base_url = var.circleci_oidc_provider_base_url
  circleci_oidc_org_id = var.circleci_oidc_org_id
  circleci_oidc_provider_arn = aws_iam_openid_connect_provider.circleci_oidc_provider.arn
}

# module "YOUR_PROJECT_NAME" {
#   source = "./projects/YOUR_PROJECT_NAME"
#   circleci_project_id = "YOUR_PROJECT_ID"
#   circleci_oidc_provider_base_url = var.circleci_oidc_provider_base_url
#   circleci_oidc_org_id = var.circleci_oidc_org_id
#   circleci_oidc_provider_arn = aws_iam_openid_connect_provider.circleci_oidc_provider.arn
# }
