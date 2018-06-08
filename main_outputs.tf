# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

## Public Route table ids
output "public_route_table_ids" {
  description = "Public route table ids"
  value       = "${module.vpc.public_route_table_ids}"
}

output "private_route_table_ids" {
  description = "Private route table ids"
  value       = "${module.vpc.private_route_table_ids}"
}

output "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  value       = "${module.vpc.vpc_cidr_block}"
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc.private_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnets}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.vpc.nat_public_ips}"]
}

# VPN
output "vpn_public_ip" {
  description = "Public facing IP address for the ALM VPN"
  value       = "${module.vpn.elastic_ip}"
}
