vpc_name = "sandbox-alm"

environment = "sandbox-alm"

root_domain_name = "smartcolumbusos.com"

credentials_profile = "sandbox"

openvpn_admin_password_secret_arn = "arn:aws:secretsmanager:us-east-2:068920858268:secret:openvpn_admin_password-8p4kVH"

docker_registry = "068920858268.dkr.ecr.us-east-2.amazonaws.com"

## Cluster variables
cluster_instance_ssh_public_key_path = "~/.ssh/id_rsa.pub"

cluster_instance_type = "t2.small"

cluster_minimum_size = 1

cluster_maximum_size = 3

cluster_desired_capacity = 2

## Load Balancer variables
domain_name = "deliveryPipeline.smartcolumbusos.com"

## Service variables

alm_account_id = "068920858268"
