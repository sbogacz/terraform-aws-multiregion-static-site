resource "aws_cloudfront_origin_access_identity" "website_origin_access_identity" {
  comment = "${var.website} access identity"
}

locals {
  replication_domain_name = "${var.replication_bucket_domain_name == "" ? var.website_bucket_domain_name : var.replication_bucket_domain_name}"
  domain_name             = "${var.failover ? local.replication_domain_name : var.website_bucket_domain_name}"
}

resource "aws_cloudfront_distribution" "website-distribution" {
  depends_on = ["aws_cloudfront_origin_access_identity.website_origin_access_identity"]

  tags = "${var.tags}"

  origin {
    domain_name = "${local.domain_name}"
    origin_id   = "s3-${var.website}-assets"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.website_origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.website} assets"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "s3-${var.website}-assets"
    compress         = true

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = false
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
