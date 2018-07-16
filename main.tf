provider "aws" {
  region  = "${var.region}"
  profile = "${var.credentials_profile}"
}

terraform {
  backend "s3" {
    bucket         = "scos-sandbox-terraform-state"
    key            = "alm"
    region         = "us-east-2"
    role_arn       = "arn:aws:iam::068920858268:role/admin_role"
    dynamodb_table = "terraform_lock_sandbox"
    encrypt        = true
  }
}

data "aws_secretsmanager_secret_version" "openvpn_admin_password" {
  secret_id = "${var.openvpn_admin_password_secret_arn}"
}

resource "aws_key_pair" "cloud_key" {
  key_name   = "cloud_key"
  public_key = "${var.key_pair_public_key}"
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-2"
}

variable "credentials_profile" {
  description = "The AWS credentials profile to use for this execution"
}

variable "owner" {
  description = "User creating this VPC. It should be done through jenkins"
  default     = "jenkins"
}

variable "environment" {
  description = "VPC environment. It can be sandbox, dev, staging or production"
}

variable "cluster_instance_ssh_public_key_path" {
  description = "AWS The path to the public key to use for the container instances"
}

variable "allowed_cidrs" {
  description = "The CIDRs allowed access to containers"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "openvpn_admin_password_secret_arn" {
  description = "The arn of the openvpn admin password."
}

variable "key_pair_public_key" {
  description = "The public key used to create a key pair"
}
