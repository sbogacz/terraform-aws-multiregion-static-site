locals {
  bucket_domain_name = "${var.replication_enabled} ? aws_s3_bucket.replicated_website.bucket_domain_name : aws_s3_bucket.website.bucket_domain_name"
}

output "bucket_domain_name" {
  description = "the domain name of the primary bucket"
  value       = "${local.bucket_domain_name}"
}

output "replication_bucket_domain_name" {
  description = "the domain name of the replicated bucket, will be empty string if replication not enabled"
  value       = "${aws_s3_bucket.website_replication.bucket_domain_name}"
}
