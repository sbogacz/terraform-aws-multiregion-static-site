provider "aws" {
  region = "us-east-1"
}

module "my-website" {
  source                           = "../../"
  domain                           = "mysite.io"
  http_method_configuration        = "read-and-options"
  cached_http_method_configuration = "read-and-options"
  acm_certificate_arn              = "arn:aws:acm:us-east-1:<account-id>:certificate/<certificate-id>"
}
