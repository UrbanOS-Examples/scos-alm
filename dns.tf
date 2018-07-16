resource "aws_route53_zone" "smartcolumbusos_public_hosted_zone" {
  name          = "${var.environment}.${var.root_domain_name}"
  force_destroy = true

  tags = {
    Environment = "${var.environment}"
  }
}

variable "root_domain_name" {
  description = "Name of root domain (ex. example.com)"
}
