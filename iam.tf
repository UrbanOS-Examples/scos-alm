module "iam_stack" {
  source                  = "git@github.com:SmartColumbusOS/scos-tf-iam?ref=3.0.0"
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnets
  ssh_key                 = aws_key_pair.cloud_key.key_name
  management_cidr         = var.vpc_cidr
  realm_cidr              = "10.0.0.0/8"
  iam_hostname_prefix     = "iam"
  zone_id                 = aws_route53_zone.public_hosted_zone.zone_id
  zone_name               = replace(aws_route53_zone.public_hosted_zone.name, "/\\.$/", "")
  realm_name              = var.kerberos_realm_name
  vpc_cidr                = var.vpc_cidr
  recovery_window_in_days = var.recovery_window_in_days
  alb_certificate         = module.tls_certificate.arn
  freeipa_version         = "4.8.6-1.fc32"

  extra_users_count = 2
  extra_users = [
    {
      username   = "binduser"
      password   = random_string.bind_user_password.result
      first_name = "bind"
      last_name  = "user"
      groups     = ""
    },
    {
      username   = "sa-discovery-api"
      password   = random_string.discovery_api_user_password.result
      first_name = "sa"
      last_name  = "discovery-api"
      groups     = "user,admin"
    },
  ]
}

resource "random_string" "bind_user_password" {
  length  = 40
  special = false
}

resource "aws_secretsmanager_secret" "bind_user_password" {
  name                    = "${terraform.workspace}-bind-user-password"
  recovery_window_in_days = var.recovery_window_in_days
}

resource "aws_secretsmanager_secret_version" "bind_user_password" {
  secret_id     = aws_secretsmanager_secret.bind_user_password.id
  secret_string = random_string.bind_user_password.result
}

resource "random_string" "discovery_api_user_password" {
  length  = 40
  special = false
}

resource "aws_secretsmanager_secret" "discovery_api_user_password" {
  name                    = "${terraform.workspace}-discovery-api-user-password"
  recovery_window_in_days = var.recovery_window_in_days
}

resource "aws_secretsmanager_secret_version" "discovery_api_user_password" {
  secret_id     = aws_secretsmanager_secret.discovery_api_user_password.id
  secret_string = random_string.discovery_api_user_password.result
}

variable "kerberos_realm_name" {
  description = "The name of the kerberos realm under management in domain format"
  default     = "internal.smartcolumbusos.com"
}

variable "recovery_window_in_days" {
  description = "How long to allow secrets to be recovered if they are deleted"
  default     = 30
}

output "freeipa_server_ips" {
  value = [module.iam_stack.freeipa_server_ips]
}

output "keycloak_server_ip" {
  value = module.iam_stack.keycloak_server_ip
}

output "bind_user_password_secret_id" {
  description = "The SecretsManager ID for the bind user password"
  value       = aws_secretsmanager_secret_version.bind_user_password.arn
}

output "discovery_api_user_password_secret_id" {
  description = "The SecretsManager ID for the discovery-api user password"
  value       = aws_secretsmanager_secret_version.discovery_api_user_password.arn
}

output "reverse_dns_zone_id" {
  value = module.iam_stack.reverse_dns_zone_id
}

output "freeipa_master_instance_id" {
  description = "The instance id the iam-master ec2 instance"
  value       = module.iam_stack.freeipa_master_instance_id
}
