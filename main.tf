module "s3" {
  source = "./modules/s3"

  aws_region  = "${var.aws_region}"
  bucket_name = "${var.bucket_name}"

  tags       = "${var.tags}"
  index_page = "${var.index_page}"
  error_page = "${var.error_page}"

  # Logging 
  logs_prefix = "${var.logs_prefix}"

  # Replication
  replication_enabled    = "${var.replication_aws_region != ""}"
  replication_aws_region = "${var.replication_aws_region}"
}

locals {
  read-and-options = ["GET", "HEAD", "OPTIONS"]
  read             = ["GET", "HEAD"]
  all              = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

  # hackery to allow list conditional
  http_methods        = ["${split(",", var.http_method_configuration == "read" ? join(",", local.read) : join(",", local.all))}"]
  cached_http_methods = ["${split(",", var.cached_http_method_configuration == "read" ? join(",", local.read) : join(",", local.all))}"]

  #cached_http_methods = ["${var.cached_http_method_configuration == "read" ? local.read : local.all}"]
}

module "cloudfront" {
  source  = "./modules/cloudfront"
  website = "${var.website}"

  tags     = "${var.tags}"
  failover = "${var.failover}"

  replication_enabled                    = "${var.replication_aws_region != ""}"
  website_bucket_domain_name             = "${module.s3.bucket_domain_name}"
  replication_bucket_domain_name         = "${module.s3.replication_bucket_domain_name}"
  logging_bucket_domain_name             = "${module.s3.logging_bucket_domain_name}"
  replication_logging_bucket_domain_name = "${module.s3.replication_logging_bucket_domain_name}"

  # HTTP methods
  http_methods = ["${split(",", var.http_method_configuration == "read-and-options" ? join(",", local.read-and-options) : join(",", local.http_methods))}"]

  # cached HTTP methods
  cached_http_methods = ["${split(",", var.cached_http_method_configuration == "read-and-options" ? join(",", local.read-and-options) : join(",", local.cached_http_methods))}"]
}
