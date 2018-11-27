module "iam_stack" {
  source                  = "../modules/iam"
  vpc_id                  = "${module.vpc.vpc_id}"
  subnet_ids              = ["${module.vpc.private_subnets}"]
  ssh_key                 = "${aws_key_pair.cloud_key.key_name}"
  management_cidr         = "${var.vpc_cidr}"
  realm_cidr              = "10.0.0.0/8"
  iam_hostname_prefix     = "iam"
  zone_id                 = "${aws_route53_zone.public_hosted_zone.zone_id}"
  zone_name               = "${aws_route53_zone.public_hosted_zone.name}"
  realm_name              = "${var.kerberos_realm_name}"
  vpc_cidr                = "${var.vpc_cidr}"
  freeipa_replica_count   = "${var.freeipa_replica_count}"
  recovery_window_in_days = "${var.recovery_window_in_days}"
}

variable "kerberos_realm_name" {
  description = "The name of the kerberos realm under management in domain format"
  default     = "internal.smartcolumbusos.com"
}

variable "freeipa_replica_count" {
  description = "The number of freeipa replicas to deploy"
  default     = 1
}

variable "recovery_window_in_days" {
  description = "How long to allow secrets to be recovered if they are deleted"
  default     = 30
}

output "freeipa_server_ips" {
  value = ["${module.iam_stack.freeipa_server_ips}"]
}

output "keycloak_server_ip" {
  value = "${module.iam_stack.keycloak_server_ip}"
}

output "bind_user_password_secret_id" {
  value = "${module.iam_stack.bind_user_password_secret_id}"
}
