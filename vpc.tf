module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.32.0"

  name = var.vpc_name
  cidr = var.vpc_cidr
  azs  = var.vpc_azs

  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = true

  enable_vpn_gateway       = var.vpc_enable_vpn_gateway
  enable_s3_endpoint       = var.vpc_enable_s3_endpoint
  enable_dynamodb_endpoint = var.vpc_enable_dynamodb_endpoint
  enable_dns_hostnames     = var.vpc_enable_dns_hostnames

  tags = {
    Owner       = var.owner
    Environment = var.environment
    Name        = var.vpc_name
  }
}

variable "vpc_name" {
  description = "The name of the VPC"
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

variable "vpc_single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = false
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

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_route_table_ids" {
  description = "Public route table ids"
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "Private route table ids"
  value       = module.vpc.private_route_table_ids
}

output "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = [module.vpc.private_subnets]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = [module.vpc.public_subnets]
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = [module.vpc.nat_public_ips]
}

