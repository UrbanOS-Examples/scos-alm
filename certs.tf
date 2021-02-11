# FUTURE FOOTGUN - THIS AND NEWER AWS PROVIDER DO NOT PLAY NICE, BUT TO UPDATE THE CERT NEEDS TO BE REBUILT
module "tls_certificate" {
  source = "github.com/azavea/terraform-aws-acm-certificate?ref=3.0.0"

  domain_name               = "*.${aws_route53_zone.public_hosted_zone.name}"
  subject_alternative_names = []
  hosted_zone_id            = aws_route53_zone.public_hosted_zone.zone_id
  validation_record_ttl     = "60"
}

output "tls_certificate_arn" {
  description = "ARN of the generated TLS certificate for the environment."
  value       = module.tls_certificate.arn
}

