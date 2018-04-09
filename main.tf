module "s3" {
  source = "./modules/s3"

  aws_region  = "${var.aws_region}"
  bucket_name = "${var.domain}-bucket"

  tags       = "${var.tags}"
  index_page = "${var.index_page}"
  error_page = "${var.error_page}"

  # Logging 
  logs_prefix = "${var.logs_prefix}"

  # Replication
  replication_enabled    = "${var.enable_replication}"
  replication_aws_region = "${var.replication_aws_region}"

  # Force destroy
  force_destroy = "${var.force_destroy}"
}

locals {
  read-and-options = ["GET", "HEAD", "OPTIONS"]
  read             = ["GET", "HEAD"]
  all              = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

  # hackery to allow list conditional
  http_methods        = ["${split(",", var.http_method_configuration == "read" ? join(",", local.read) : join(",", local.all))}"]
  cached_http_methods = ["${split(",", var.cached_http_method_configuration == "read" ? join(",", local.read) : join(",", local.all))}"]
}

module "cloudfront" {
  source = "./modules/cloudfront"
  domain = "${var.domain}"

  tags = "${var.tags}"

  # S3 configuration
  access_identity_path                   = "${module.s3.cloudfront_access_identity_path}"
  replication_enabled                    = "${var.replication_aws_region != ""}"
  website_bucket_domain_name             = "${module.s3.bucket_domain_name}"
  replication_bucket_domain_name         = "${module.s3.replication_bucket_domain_name}"
  logging_bucket_domain_name             = "${module.s3.logging_bucket_domain_name}"
  replication_logging_bucket_domain_name = "${module.s3.replication_logging_bucket_domain_name}"

  # Failover
  failover = "${var.failover}"

  # HTTP methods
  http_methods = ["${split(",", var.http_method_configuration == "read-and-options" ? join(",", local.read-and-options) : join(",", local.http_methods))}"]

  # cached HTTP methods
  cached_http_methods = ["${split(",", var.cached_http_method_configuration == "read-and-options" ? join(",", local.read-and-options) : join(",", local.cached_http_methods))}"]

  # cert
  acm_certificate_arn = "${var.acm_certificate_arn}"
}
