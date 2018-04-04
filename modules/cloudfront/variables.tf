variable "website" {
  type        = "string"
  description = "name of the website you're creating CloudFront assets for"
}

variable "website_bucket_domain_name" {
  type        = "string"
  description = "the bucket domain name corresponding to the S3 bucket holding the assets"
}

variable "replication_bucket_domain_name" {
  type        = "string"
  description = "[OPTIONAL IF NOT IN FAILOVER] the replication bucket domain name corresponding to the S3 bucket holding the assets"
  default     = ""
}

variable "failover" {
  default     = false
  description = "a boolean indicating whether you want to change the CloudFront origin to point to the replication bucket. If set to true, replication_bucket_domain_name MUST BE SET"
}

variable "tags" {
  type        = "map"
  description = "optional tags to attach to the created s3 resources"
  default     = {}
}
