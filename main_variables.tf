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

variable "vpc_name" {
  description = "The name of the VPC"
}

variable "vpc_single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = false
}

variable "environment" {
  description = "VPC environment. It can be sandbox, dev, staging or production"
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "A list of availability zones in the region"
  default     = ["us-east-2a"]
}

variable "vpc_private_subnets" {
  description = "CIDR blocks for Private Subnets"
  default     = ["10.0.0.0/19"]
}

variable "vpc_public_subnets" {
  description = "CIDR blocks for Public Subnets"
  default     = ["10.0.32.0/20"]
}

variable "vpc_enable_nat_gateway" {
  description = "Provision NAT Gateways for each of your availability zones"
  default     = true
}

variable "vpc_enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  default     = true
}

variable "vpc_enable_s3_endpoint" {
  description = "Should be true if you want to provision an S3 endpoint to the VPC"
  default     = true
}

variable "vpc_enable_dynamodb_endpoint" {
  description = "Should be true if you want to provision a DynamoDB endpoint to the VPC"
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = true
}

# OpenVPN
variable "openvpn_admin_username" {
  description = "Username for the OpenVPN Access Server administrative user"
  default     = "openvpn"
}

variable "openvpn_admin_password_secret_arn" {
  description = "AWS SecretsManager ARN for the OpenVPN admin password"
}
