module "tls_certificate" {
  source = "github.com/azavea/terraform-aws-acm-certificate?ref=0.1.0"

  domain_name               = "*.${aws_route53_zone.public_hosted_zone.name}"
  subject_alternative_names = []
  hosted_zone_id            = "${aws_route53_zone.public_hosted_zone.zone_id}"
  validation_record_ttl     = "60"
}
