vpc_name = "alm"

environment = "alm"

credentials_profile = "jenkins"

openvpn_admin_password_secret_arn = "arn:aws:secretsmanager:us-east-2:199837183662:secret:openvpn_admin_password-beMNOa"

vpc_private_subnets = ["10.0.0.0/19", "10.0.64.0/19", "10.0.128.0/19"]

vpc_public_subnets = ["10.0.32.0/20", "10.0.96.0/20", "10.0.160.0/20"]

vpc_azs = ["us-east-2a", "us-east-2b", "us-east-2c"]

docker_registry = "199837183662.dkr.ecr.us-east-2.amazonaws.com"

cluster_instance_ssh_public_key_path = "~/.ssh/id_rsa.pub"

cluster_instance_type = "t2.small"

cluster_minimum_size = 1

cluster_maximum_size = 3

cluster_desired_capacity = 2

domain_name = "deliveryPipeline.smartcolumbusos.com"

alm_account_id = "199837183662"
