# terraform-website
A repo to hold a Terraform module that simplifies website deploys.

> WIP: YOU HAVE BEEN WARNED!
> ALSO, THIS IS A PRIVATE REPO, SO EXTRA WARNED!!!


Currently this only supports the S3 bucket operations. The configuration should roughly match what is required for website hosting, with logging, and with optional cross-region replication.

## Example Usage: Simple
```hcl
module "tests3" {
  source = "git::https://github.com/sbogacz/terraform-website"

  bucket_name = "test-website-321"

  tags = {
    ApplicationName       = "web-dev-test"
    Environment           = "sandbox"
  }
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

  enable_replication     = true
  replication_aws_region = "us-west-2"
}
```
