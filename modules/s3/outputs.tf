locals {
  replicated_domain                      = ["${coalescelist(aws_s3_bucket.replicated_website.*.bucket_domain_name, list(""))}"]
  non_replicated_domain                  = ["${coalescelist(aws_s3_bucket.website.*.bucket_domain_name, list(""))}"]
  bucket_domain_name                     = "${var.replication_enabled ? local.replicated_domain[0] : local.non_replicated_domain[0]}"
  replication_bucket_domain_name         = ["${coalescelist(aws_s3_bucket.website_replication.*.bucket_domain_name, list(""))}"]
  replication_logging_bucket_domain_name = ["${coalescelist(aws_s3_bucket.website_replication_logging.*.bucket_domain_name, list(""))}"]

  # Compute ARN
  replicated_arn         = ["${coalescelist(aws_s3_bucket.replicated_website.*.arn, list(""))}"]
  non_replicated_arn     = ["${coalescelist(aws_s3_bucket.website.*.arn, list(""))}"]
  bucket_arn             = "${var.replication_enabled ? local.replicated_arn[0] : local.non_replicated_arn[0]}"
  replicated_bucket_arns = ["${coalescelist(aws_s3_bucket.website_replication.*.arn, list(""))}"]
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
  value       = "${local.replication_bucket_domain_name[0]}"
}

output "replication_logging_bucket_domain_name" {
  description = "the domain name of the replication's logging bucket"
  value       = "${local.replication_logging_bucket_domain_name[0]}"
}

output "bucket_arn" {
  description = "the ARN of the primary bucket"
  value       = "${local.bucket_arn}"
}

output "replication_bucket_arn" {
  description = "the ARN of the replicated bucket"
  value       = "${local.replicated_bucket_arns[0]}"
}
