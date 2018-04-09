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

variable "tags" {
  type        = "map"
  description = "optional tags to attach to the created s3 resources"
  default     = {}
}

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

variable "replication_enabled" {
  default     = false
  description = "a boolean to indicate if cross-region replication is desired. NOTE: This will make the replication region variable required!"
}

variable "replication_aws_region" {
  type        = "string"
  description = "the AWS region to deploy the replicated S3 resources to"
}

variable "force_destroy" {
  default     = false
  description = "a passthrough variable to the created s3 buckets to allow the terraform destroy to succeed in the event that objects are present. Be warned, these objects will NOT be recoverable"
}
