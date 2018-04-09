# S3 
output "bucket_website_endpoint" {
  description = "the domain name of the primary bucket"
  value       = "${module.s3.bucket_website_endpoint}"
}

output "replication_bucket_website_endpoint" {
  description = "the domain name of the replicated bucket, will be empty string if replication not enabled"
  value       = "${module.s3.replication_bucket_website_endpoint}"
}

output "bucket_arn" {
  description = "the ARN of the primary bucket"
  value       = "${module.s3.bucket_arn}"
}

output "replication_bucket_arn" {
  description = "the ARN of the replicated bucket, will be empty string if replication not enabled"
  value       = "${module.s3.replication_bucket_arn}"
}

# CloudFront
output "cloudfront_distribution_arn" {
  description = "the ARN of the created CloudFront distribution"
  value       = "${module.cloudfront.cf_distribution_arn}"
}

output "cloudfront_distribution_id" {
  description = "the ID of the created CloudFront distribution"
  value       = "${module.cloudfront.cf_distribution_id}"
}

output "cloudfront_distribution_domain_name" {
  description = "the ID of the created CloudFront distribution"
  value       = "${module.cloudfront.cf_distribution_domain_name}"
}
