locals {
  replication_domain_name         = "${var.replication_bucket_domain_name == "" ? var.website_bucket_domain_name : var.replication_bucket_domain_name}"
  domain_name                     = "${var.failover ? local.replication_domain_name : var.website_bucket_domain_name}"
  replication_logging_domain_name = "${var.replication_logging_bucket_domain_name == "" ? var.logging_bucket_domain_name : var.replication_logging_bucket_domain_name}"
  logging_domain_name             = "${var.failover ? local.replication_logging_domain_name : var.logging_bucket_domain_name}"
  www_alias                       = ["${var.domain}", "www.${var.domain}"]
}

resource "aws_cloudfront_distribution" "website-distribution" {
  tags = "${var.tags}"

  aliases = ["${coalescelist(local.www_alias,var.aliases)}"]

  origin {
    domain_name = "${local.domain_name}"
    origin_id   = "s3-${var.domain}-assets"

    s3_origin_config {
      origin_access_identity = "${var.access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.domain} assets"
  default_root_object = "${var.index_page}"

  default_cache_behavior {
    allowed_methods  = ["${var.http_methods}"]
    cached_methods   = ["${var.cached_http_methods}"]
    target_origin_id = "s3-${var.domain}-assets"
    compress         = true

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = false
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = "${var.min_ttl}"
    default_ttl            = "${var.default_ttl}"
    max_ttl                = "${var.max_ttl}"
  }

  logging_config {
    bucket = "${local.logging_domain_name}"
    prefix = "${var.domain}-cf"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = "${var.acm_certificate_arn == ""}"
    acm_certificate_arn            = "${var.acm_certificate_arn}"
    ssl_support_method             = "sni-only"
  }
}
