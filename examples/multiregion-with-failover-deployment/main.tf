provider "aws" {
  region = "us-east-1"
}

module "my-website" {
  source = "../../"

  # tags if you want any
  tags = {
    website = "mysite.io"
    use     = "personal"
  }

  domain                           = "mysite.io"
  http_method_configuration        = "read-and-options"
  cached_http_method_configuration = "read-and-options"

  acm_certificate_arn = "arn:aws:acm:us-east-1:<acount-id>:certificate/<certificate-id>"

  # enable cross region replication
  enable_replication     = true
  replication_aws_region = "us-west-2"

  # use the replication bucket as the origin source 
  # for cloudfront, if something went wrong
  failover = true
}
