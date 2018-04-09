locals {
  replicated_website_endpoint            = ["${coalescelist(aws_s3_bucket.replicated_website.*.website_endpoint, list(""))}"]
  non_replicated_website_endpoint        = ["${coalescelist(aws_s3_bucket.website.*.website_endpoint, list(""))}"]
  bucket_website_endpoint                = "${var.replication_enabled ? local.replicated_website_endpoint[0] : local.non_replicated_website_endpoint[0]}"
  replication_bucket_website_endpoint    = ["${coalescelist(aws_s3_bucket.website_replication.*.website_endpoint, list(""))}"]
  replication_logging_bucket_domain_name = ["${coalescelist(aws_s3_bucket.website_replication_logging.*.bucket_domain_name, list(""))}"]

  # Compute ARN
  replicated_arn         = ["${coalescelist(aws_s3_bucket.replicated_website.*.arn, list(""))}"]
  non_replicated_arn     = ["${coalescelist(aws_s3_bucket.website.*.arn, list(""))}"]
  bucket_arn             = "${var.replication_enabled ? local.replicated_arn[0] : local.non_replicated_arn[0]}"
  replicated_bucket_arns = ["${coalescelist(aws_s3_bucket.website_replication.*.arn, list(""))}"]
}

output "bucket_website_endpoint" {
  description = "the website_endpoint name of the primary bucket"
  value       = "${local.bucket_website_endpoint}"
}

output "logging_bucket_domain_name" {
  description = "the domain name of the primary's logging bucket"
  value       = "${aws_s3_bucket.website_logging.bucket_domain_name}"
}

output "replication_bucket_website_endpoint" {
  description = "the website_endpoint name of the replicated bucket, will be empty string if replication not enabled"
  value       = "${local.replication_bucket_website_endpoint[0]}"
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

output "cloudfront_access_identity_path" {
  description = "the CloudFront Origin Access Identity Path that will be needed for the distribution"
  value       = "${aws_cloudfront_origin_access_identity.website_oai.cloudfront_access_identity_path}"
}
