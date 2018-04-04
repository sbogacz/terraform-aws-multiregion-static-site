module "s3" {
  source = "./modules/s3"

  aws_region  = "${var.aws_region}"
  bucket_name = "${var.bucket_name}"

  tags       = "${var.tags}"
  index_page = "${var.index_page}"
  error_page = "${var.error_page}"

  # Logging 
  logs_prefix = "${var.logs_prefix}"

  # Replication
  enable_replication     = "${var.enable_replication}"
  replication_aws_region = "${var.replication_aws_region}"
}
