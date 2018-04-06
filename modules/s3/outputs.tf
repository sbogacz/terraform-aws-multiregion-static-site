locals {
  replicated_domain     = "${element(aws_s3_bucket.replicated_website.*.bucket_domain_name,1)}"
  non_replicated_domain = "${element(aws_s3_bucket.website.*.bucket_domain_name,1)}"
  bucket_domain_name    = "${var.replication_enabled} ? local.replicated_domain : local.non_replicated_domain"
}

output "bucket_domain_name" {
  description = "the domain name of the primary bucket"
  value       = "${local.bucket_domain_name}"
}

output "logging_bucket_domain_name" {
  description = "the domain name of the primary's logging bucket"
  value       = "${aws_s3_bucket.website_logging.bucket_domain_name}"
}

output "replication_bucket_domain_name" {
  description = "the domain name of the replicated bucket, will be empty string if replication not enabled"
  value       = "${element(aws_s3_bucket.website_replication.*.bucket_domain_name,1)}"
}

output "replication_logging_bucket_domain_name" {
  description = "the domain name of the replication's logging bucket"
  value       = "${element(aws_s3_bucket.website_replication_logging.*.bucket_domain_name,1)}"
}
