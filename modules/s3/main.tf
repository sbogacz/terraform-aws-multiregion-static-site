# Logging bucket
resource "aws_s3_bucket" "website_logging" {
  bucket = "${var.bucket_name}-logs"
  acl    = "log-delivery-write"

  region = "${var.aws_region}"

  tags = "${var.tags}"
}

# Simple website bucket
resource "aws_s3_bucket" "website" {
  # if not replication, create
  count  = "${var.enable_replication ? 0 : 1}"
  bucket = "${var.bucket_name}"
  acl    = "private"

  region = "${var.aws_region}"

  tags = "${var.tags}"

  # website configuration
  website {
    index_document = "${var.index_page}"
    error_document = "${var.error_page}"
  }

  # logging is a good idea
  logging {
    target_bucket = "${aws_s3_bucket.website_logging.id}"
    target_prefix = "${var.logs_prefix}"
  }
}

provider "aws" {
  alias  = "replication"
  region = "${var.replication_aws_region}"
}

# Replication destination
resource "aws_s3_bucket" "website_replication_logging" {
  count = "${var.enable_replication ? 1 : 0}"

  provider = "aws.replication"
  bucket   = "${var.bucket_name}-replication-logs"
  acl      = "log-delivery-write"

  region = "${var.replication_aws_region}"

  tags = "${var.tags}"
}

# Replication destination
resource "aws_s3_bucket" "website_replication" {
  count    = "${var.enable_replication ? 1 : 0}"
  provider = "aws.replication"
  bucket   = "${var.bucket_name}-replication"
  acl      = "public-read"

  region = "${var.replication_aws_region}"

  tags = "${var.tags}"

  # website configuration
  website {
    index_document = "${var.index_page}"
    error_document = "${var.error_page}"
  }

  # logging is a good idea
  logging {
    target_bucket = "${aws_s3_bucket.website_replication_logging.id}"
    target_prefix = "${var.logs_prefix}"
  }

  versioning {
    enabled = true
  }
}

# This is the IAM roles and policies required for cross-region replication
resource "aws_iam_role" "replication" {
  count = "${var.enable_replication ? 1 : 0}"
  name  = "${var.bucket_name}_replication_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
  count = "${var.enable_replication ? 1 : 0}"
  name  = "${var.bucket_name}_replication_policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.replicated_website.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.replicated_website.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.website_replication.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication" {
  count      = "${var.enable_replication ? 1 : 0}"
  name       = "${var.bucket_name}_replication_role_policy_attachment"
  roles      = ["${aws_iam_role.replication.name}"]
  policy_arn = "${aws_iam_policy.replication.arn}"
}

# Cross-region replicated website bucket
resource "aws_s3_bucket" "replicated_website" {
  # if not replication, create
  count = "${var.enable_replication ? 1 : 0}"

  #  depends_on = ["aws_iam_role.replication", "aws_iam_policy.replication", "aws_iam_policy_attachment.replication", "aws_s3_bucket.website_replication"]
  bucket = "${var.bucket_name}"
  acl    = "private"

  region = "${var.aws_region}"

  tags = "${var.tags}"

  # website configuration
  website {
    index_document = "${var.index_page}"
    error_document = "${var.error_page}"
  }

  # logging is a good idea
  logging {
    target_bucket = "${aws_s3_bucket.website_logging.id}"
    target_prefix = "${var.logs_prefix}"
  }

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.replication.arn}"

    rules {
      destination {
        bucket        = "${aws_s3_bucket.website_replication.arn}"
        storage_class = "STANDARD"
      }

      prefix = ""
      status = "Enabled"
    }
  }
}
