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

## Opinionated Omissions 

* This module doesn't try to do any of the DNS configuration for you, simply because there is so much variation in required entries based on having a mail provider (if so, which one), where you registered your domain, etc. The module does provide the cloudfront ARN as an output, so you could use it to configure your own route 53 module
* This also assumes that you're passing in the Amazon Certificate Manage ARN for your cert (if not, it will use the default CloudFront cert, which will enable HTTPS only for the CloudFront URL. An earlier version did take in the public and private keys to create the resource for you and configure it, but we're choosing to separate the cert process out so as not to have the `tfstate` file hold any secrets.

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
