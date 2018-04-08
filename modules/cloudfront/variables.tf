/********************************************************
 * Website specific configuration
 *******************************************************/
variable "website" {
  type        = "string"
  description = "name of the website you're creating CloudFront assets for"
}

variable "tags" {
  type        = "map"
  description = "optional tags to attach to the created s3 resources"
  default     = {}
}

variable "http_methods" {
  default     = ["GET", "HEAD", "OPTIONS"]
  description = "the HTTP methods to allow on the CloudFront distribution"
}

variable "index_page" {
  type        = "string"
  description = "path to the desired index page"
  default     = "index.html"
}

variable "price_class" {
  description = "the desired price class to use. PriceClass_All, PriceClass_200, and PriceClass_100 are also acceptable"
  default     = "PriceClass_All"
}

variable "aliases" {
  type        = "list"
  description = "if your cert is for a different (non-CloudFront domain) specify the domain names and their aliases (e.g. mywebsite.com, www.mywebsite.com)"
  default     = []
}

/********************************************************
 * S3 bucket configuration stuff
 *******************************************************/
variable "replication_enabled" {
  default     = false
  description = "a boolean to indicate if cross-region replication is desired. NOTE: This will make the replication region variable required!"
}

variable "website_bucket_domain_name" {
  type        = "string"
  description = "the bucket domain name corresponding to the S3 bucket holding the assets"
}

variable "logging_bucket_domain_name" {
  type        = "string"
  description = "the logging bucket domain name corresponding to the S3 bucket holding the logs for the website asset bucket"
}

variable "replication_bucket_domain_name" {
  type        = "string"
  description = "[OPTIONAL IF NOT IN FAILOVER] the replication bucket domain name corresponding to the S3 bucket holding the assets"
  default     = ""
}

variable "replication_logging_bucket_domain_name" {
  type        = "string"
  description = "[OPTIONAL IF NOT IN FAILOVER] the replication logging bucket domain name corresponding to the S3 bucket holding the logs for the website asset bucket"
  default     = ""
}

variable "failover" {
  default     = false
  description = "a boolean indicating whether you want to change the CloudFront origin to point to the replication bucket. If set to true, replication_bucket_domain_name MUST BE SET"
}

/********************************************************
 * Cache behavior
 *******************************************************/
variable "cached_http_methods" {
  default     = ["GET", "HEAD", "OPTIONS"]
  description = "the HTTP methods to allow on the CloudFront distribution"
}

variable "min_ttl" {
  description = "the minimum TTL to set on the CloudFront cache"
  default     = 0
}

variable "default_ttl" {
  description = "the default TTL to set on the CloudFront cache"
  default     = 1800
}

variable "max_ttl" {
  description = "the maximum TTL to set on the CloudFront cache"
  default     = 86400
}

/********************************************************
 * CERT STUFF * IMPORTANT !!! *
 ********************************************************
 * If you don't provide Amazon Certificate Manager ARN, 
 * the CloudFront distribution will use the default 
 * CloudFront cert. 
 ********************************************************/
variable "acm_certificate_arn" {
  description = "if you obtained an SSL cert from AWS Route 53 for your website, then set this field to the ARN of that cert"
  default     = ""
}
