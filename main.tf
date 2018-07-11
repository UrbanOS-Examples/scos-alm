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
  secret_id = "arn:aws:secretsmanager:us-east-2:199837183662:secret:openvpn_admin_password-beMNOa"
}

resource "aws_key_pair" "cloud_key" {
  key_name   = "cloud_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRAvH6k7iEeRDz9SQtkH1o8KiUaed/e2hmzTUjA8bhmeWVLPsgCMKIUKR0jdPlvdZ0AmMLXswobsXj08dPgWxUZxoAWIqKCjd969KckydUpBtcb+X2Q+tpOcugBOQSY1H8hgNrdcRKEaUllTfvseJ9pBOYU7j9VuZ608HQhfZw7+aS8wi9o/BJwejtpWdlo6gkxXoIRqDX/ioYg+W6Tc7yoUzAEANwZAy3/3GKWDrh+9jnzR6mEEN48Nuee49wWfP5G0T/v4+Gvux5zioHb3rcmmR9YTkFOiv1poInhXlPdc7Q38yj+z6E+hACNN3rK80YjU0ByaSPltPjqm9ZYmPX"
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