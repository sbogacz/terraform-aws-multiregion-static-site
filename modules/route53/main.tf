#Route53 will set up the NS and SOA record for you

# We use alias records since we're pointing to an AWS resource
resource "aws_route53_record" "alias" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "example.com"
  type    = "A"

  alias {
    name                   = "${aws_elb.main.dns_name}"
    zone_id                = "${aws_elb.main.zone_id}"
    evaluate_target_health = true
  }
}
