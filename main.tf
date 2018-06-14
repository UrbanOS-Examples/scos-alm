provider "aws" {
  region = "${var.region}"

  profile = "${var.credentials_profile}"
}

terraform {
  backend "s3" {
    bucket         = "scos-sandbox-terraform-state"
    key            = "alm"
    region         = "us-east-2"
    dynamodb_table = "terraform_lock"
    encrypt        = true
  }
}

data "aws_secretsmanager_secret_version" "openvpn_admin_password" {
  secret_id = "${var.openvpn_admin_password_secret_arn}"
}

resource "aws_key_pair" "cloud_key" {
  key_name   = "cloud_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRAvH6k7iEeRDz9SQtkH1o8KiUaed/e2hmzTUjA8bhmeWVLPsgCMKIUKR0jdPlvdZ0AmMLXswobsXj08dPgWxUZxoAWIqKCjd969KckydUpBtcb+X2Q+tpOcugBOQSY1H8hgNrdcRKEaUllTfvseJ9pBOYU7j9VuZ608HQhfZw7+aS8wi9o/BJwejtpWdlo6gkxXoIRqDX/ioYg+W6Tc7yoUzAEANwZAy3/3GKWDrh+9jnzR6mEEN48Nuee49wWfP5G0T/v4+Gvux5zioHb3rcmmR9YTkFOiv1poInhXlPdc7Q38yj+z6E+hACNN3rK80YjU0ByaSPltPjqm9ZYmPX"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.32.0"

  name = "${var.vpc_name}"
  cidr = "${var.vpc_cidr}"
  azs  = "${var.vpc_azs}"

  private_subnets = "${var.vpc_private_subnets}"
  public_subnets  = "${var.vpc_public_subnets}"

  enable_nat_gateway = "${var.vpc_enable_nat_gateway}"
  single_nat_gateway = "${var.vpc_single_nat_gateway}"

  enable_vpn_gateway       = "${var.vpc_enable_vpn_gateway}"
  enable_s3_endpoint       = "${var.vpc_enable_s3_endpoint}"
  enable_dynamodb_endpoint = "${var.vpc_enable_dynamodb_endpoint}"
  enable_dns_hostnames     = "${var.vpc_enable_dns_hostnames}"

  tags = {
    Owner       = "${var.owner}"
    Environment = "${var.environment}"
    Name        = "${var.vpc_name}"
  }
}

module "vpn" {
  source = "../modules/vpn"

  private_subnet_id = "${module.vpc.private_subnets[0]}"
  public_subnet_id  = "${module.vpc.public_subnets[0]}"
  vpc_id            = "${module.vpc.vpc_id}"
  admin_user        = "${var.openvpn_admin_username}"
  admin_password    = "${data.aws_secretsmanager_secret_version.openvpn_admin_password.secret_string}"
  key_name          = "${aws_key_pair.cloud_key.key_name}"
}

module "proxy_cluster" {
  source = "./proxy-cluster"

  region                               = "${var.region}"
  vpc_id                               = "${module.vpc.vpc_id}"
  subnet_ids                           = "${module.vpc.private_subnets}"
  deployment_identifier                = "${var.deployment_identifier}"
  cluster_instance_ssh_public_key_path = "${var.cluster_instance_ssh_public_key_path}"
  allowed_cidrs                        = "${var.allowed_cidrs}"
  ui_host                              = "${var.cota_ui_host}"
  websocket_host                       = "${var.streaming_consumer_host}"
  alm_account_id                       = "${var.alm_account_id}"
}
