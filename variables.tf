/****************************************
 * General (AWS) Stuff
************** **************************/
variable "aws_region" {
  type        = "string"
  description = "the AWS region to deploy the S3 resources to"

  # at least it's not dumpster-fire-1
  default = "us-east-2"
}

variable "bucket_name" {
  type        = "string"
  description = "name for the bucket that will host your website"
}

/****************************************
 * General (non-AWS) Stuff
 ****************************************/
variable "tags" {
  type        = "map"
  description = "optional tags to attach to the created s3 resources"
  default     = {}
}

/****************************************
 * S3 Website Configuration Variables
 ****************************************/
variable "index_page" {
  type        = "string"
  description = "path to the desired index page"
  default     = "index.html"
}

variable "error_page" {
  type        = "string"
  description = "path to the desired error page"
  default     = "404.html"
}

variable "logs_prefix" {
  type        = "string"
  description = "the prefix to use in the logging bucket"
  default     = "logs/"
}

variable "replication_aws_region" {
  type        = "string"
  description = "the AWS region to deploy the replicated S3 resources to. If not empty, cross-region S3 replication will be enabled"
  default     = ""
}

/****************************************
 * CloudFront Configuration Variables
 ****************************************/
variable "http_method_configuration" {
  default     = "all"
  description = "determine which HTTP methods will be allowed on the CloudFront distribution. Options are all (GET,PUT,POST,DELETE,ETC.), read (GET, HEAD), and read-and-options(GET,HEAD,OPTIONS). Defaults to all, but most static website cases will want to use read or read-and-options."
}

variable "cached_http_method_configuration" {
  default     = "read-and-options"
  description = "determine which HTTP methods will be cached on the CloudFront distribution. Options are all (GET,PUT,POST,DELETE,ETC.), read (GET, HEAD), and read-and-options(GET,HEAD,OPTIONS). Defaults to read-and-options"
}

variable "failover" {
  default     = false
  description = "a boolean indicating whether you want to change the CloudFront origin to point to the replication bucket. If set to true, replication_aws_region MUST BE SET"
}
