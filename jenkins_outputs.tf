# VPC
output "efs_id" {
  description = "The ID of the EFS"
  value       = "${module.jenkins_efs.efs_id}"
}

output "kms_key_id" {
  description = "The ARN for the KMS encryption key"
  value       = "${module.jenkins_efs.kms_key_id}"
}

output "dns_name" {
  description = "The DNS name for the filesystem"
  value       = "${module.jenkins_efs.dns_name}"
}
