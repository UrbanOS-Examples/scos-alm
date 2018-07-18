resource "aws_route53_zone" "public_hosted_zone" {
  name          = "${var.environment}.${var.root_dns_name}"
  force_destroy = true

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_route53_zone" "private_hosted_zone" {
  name          = "${var.root_dns_name}"
  force_destroy = true
  vpc_id        = "${module.vpc.vpc_id}"

  tags = {
    Environment = "${var.environment}"
  }
}

variable "root_dns_name" {
  description = "Name of root domain (ex. example.com)"
}

output "name_servers" {
  value = "${aws_route53_zone.public_hosted_zone.name_servers}"
}

output "private_zone_id" {
  value = "${aws_route53_zone.private_hosted_zone.zone_id}"
}
