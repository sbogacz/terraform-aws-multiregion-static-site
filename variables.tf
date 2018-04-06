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

/********************************************************
 * Website specific configuration
 *******************************************************/
variable "website" {
  type        = "string"
  description = "name of the website you're creating CloudFront assets for"
}

variable "aliases" {
  type        = "list"
  description = "if your cert is for a different (non-CloudFront domain) specify the domain names and their aliases (e.g. mywebsite.com, www.mywebsite.com)"
  default     = []
}

/********************************************************
 * Website cache behavior
 *******************************************************/
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
 * If you don't provide either an Amazon Certificate 
 * Manager ARN, or CA cert and secret key files, then 
 * the CloudFront distribution will use the default 
 * CloudFront cert.
 ********************************************************/
variable "acm_certificate_arn" {
  description = "if you obtained an SSL cert from AWS Route 53 for your website, then set this field to the ARN of that cert"
  default     = ""
}

variable "cert_file" {
  description = "if you want to use a custom cert, then you'll have to provide the CA cert file here, and the private key file below"
  default     = ""
}

variable "private_key_filei" {
  description = "if you want to use a custom cert, then you'll have to provide the private key file here, and the CA cert file above"
  default     = ""
}
