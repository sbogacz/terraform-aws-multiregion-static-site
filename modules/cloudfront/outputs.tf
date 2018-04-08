output "cf_distribution_arn" {
  description = "the ARN of the created CloudFront distribution"
  value       = "${aws_cloudfront_distribution.website-distribution.arn}"
}

output "cf_distribution_id" {
  description = "the ID of the created CloudFront distribution"
  value       = "${aws_cloudfront_distribution.website-distribution.id}"
}

output "cf_distribution_domain_name" {
  description = "the ID of the created CloudFront distribution"
  value       = "${aws_cloudfront_distribution.website-distribution.domain_name}"
}
