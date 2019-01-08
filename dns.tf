locals {
  internal_public_hosted_zone_name = "${lower(terraform.workspace)}.${lower(var.root_dns_zone)}"
}

data "aws_route53_zone" "root_zone" {
  name = "${var.root_dns_zone}"
}

resource "aws_route53_zone" "public_hosted_zone" {
  name          = "${local.internal_public_hosted_zone_name}"
  force_destroy = true

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_route53_record" "alm_ns_record" {
  name = "${terraform.workspace}"
  zone_id = "${data.aws_route53_zone.root_zone.zone_id}"
  type = "NS"
  ttl = 300
  records = ["${aws_route53_zone.public_hosted_zone.name_servers}"]
}

variable "root_dns_zone" {
  description = "Name of root domain (ex. example.com)"
}

variable "prod_role_arn" {
  description = "Role that allows for route53 record manipulation in prod"
}

output "name_servers" {
  value = "${aws_route53_zone.public_hosted_zone.name_servers}"
}

output "public_hosted_zone_id" {
  value = "${aws_route53_zone.public_hosted_zone.zone_id}"
}

output "public_hosted_zone_name" {
  value = "${aws_route53_zone.public_hosted_zone.name}"
}
