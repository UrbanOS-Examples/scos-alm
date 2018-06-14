variable "region" {
  description = "AWS Region to create the cluster in"
  default     = "us-east-2"
}

variable "vpc_id" {
  description = "ID of the target VPC"
}

variable "subnet_ids" {
  type        = "list"
  description = "List of subnet IDs the instances should be attached to"
}

variable "deployment_identifier" {
  description = "sandbox | alm"
}

variable "cluster_instance_ssh_public_key_path" {
  description = "Public key for accessing cluster instances"
}

variable "allowed_cidrs" {
  description = "The CIDRs allowed access to containers"
  type        = "list"
}

variable "ui_host" {
  description = "DNS entry or IP of the UI"
}

variable "websocket_host" {
  description = "DNS entry or IP of the consumer's websocket"
}

variable "alm_account_id" {
  description = "Account id of the ALM environment (should match deployment_identifier env)"
}
