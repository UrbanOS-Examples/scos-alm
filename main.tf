terraform {
  backend "s3" {
    key     = "alm"
    encrypt = true
  }
}

variable "sandbox" {
  description = "Behave as if we are running in sandbox (as opposed to prod)"
  default     = true
}

variable "alm_role_arn" {
  description = "The ARN for the assume role for ALM access"
}

variable "alm_state_bucket_name" {
  description = "The name of the S3 state bucket for ALM"
}

data "aws_secretsmanager_secret_version" "openvpn_admin_password" {
  secret_id = "${var.openvpn_admin_password_secret_arn}"
}

resource "aws_key_pair" "cloud_key" {
  key_name   = "${terraform.workspace}_cloud_key"
  public_key = "${var.key_pair_public_key}"
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-2"
}

variable "owner" {
  description = "User creating this VPC. It should be done through jenkins"
  default     = "jenkins"
}

variable "environment" {
  description = "VPC environment. It can be sandbox, dev, staging or production"
}

variable "cluster_instance_ssh_public_key_path" {
  description = "AWS The path to the 'oasis@MBP-' public key to use for the container instances"
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
