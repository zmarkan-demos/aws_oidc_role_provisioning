output "circleci_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.circleci_oidc_provider.arn
}