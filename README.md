# terraform-website
A repo to hold a Terraform module that simplifies website deploys.

> WIP: YOU HAVE BEEN WARNED!

This terraform module is designed to support "static" websites (in the sense that the assets are server-side independent). 
It's fairly trim in that it only supports the creation of [S3](https://aws.amazon.com/s3/) and [CloudFront](https://aws.amazon.com/cloudfront/) resources. 

That being said, it does have some robust (albeit opinionated) features

## Features
* Logging bucket for S3 and CloudFront logs
* Support for [cross-region replication](https://docs.aws.amazon.com/AmazonS3/latest/dev/crr.html) by simply setting the `replication_aws_region` variable, including
	* necessary IAM resource creation and configuration
	* independent replication region logging bucket creation
* Support for resource tagging (on the resources that can be tagged)
* Ability to fail over to replication bucket by setting the `failover` module flag to true, and re-`terraform apply`-ing (CloudFront does not support automatic failovers as of this writing (04/06/2018)

## Example Usage: Simple
```hcl
module "tests3" {
  source = "git::https://github.com/sbogacz/terraform-website"

  bucket_name = "test-website-321"

  tags = {
    ApplicationName       = "web-dev-test"
    Environment           = "sandbox"
  }

  website = "test-website-321.io"
}
```

## Example Usage: Replicated
```hcl
module "tests3" {
  source = "git::https://github.com/sbogacz/terraform-website"

  bucket_name = "test-website-321"

  tags = {
    ApplicationName       = "web-dev-test"
    Environment           = "sandbox"
  }

  website                = "test-website-321.io"
  replication_aws_region = "us-west-2"
  failover               = true
}
```
