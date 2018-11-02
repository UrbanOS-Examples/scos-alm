module "iam_stack" {
  source              = "../modules/iam"
  vpc_id              = "${module.vpc.vpc_id}"
  subnet_ids          = ["${module.vpc.private_subnets}"]
  ssh_key             = "${aws_key_pair.cloud_key.key_name}"
  management_cidr     = "${var.vpc_cidr}"
  realm_cidr          = "10.0.0.0/8"
  iam_hostname_prefix = "iam"
  zone_id             = "${aws_route53_zone.public_hosted_zone.zone_id}"
  zone_name           = "${aws_route53_zone.public_hosted_zone.name}"
  realm_name          = "internal.smartcolumbusos.com"
  vpc_cidr            = "${var.vpc_cidr}"
}

output "freeipa_server_ips" {
  value = ["${module.iam_stack.freeipa_server_ips}"]
}

output "keycloak_server_ip" {
  value = "${module.iam_stack.keycloak_server_ip}"
}
