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
