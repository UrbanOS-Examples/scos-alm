vpc_name = "alm"

vpc_single_nat_gateway = true

environment = "alm"

credentials_profile = "jenkins"

vpc_private_subnets = ["10.0.0.0/19", "10.0.64.0/19", "10.0.128.0/19"]

vpc_public_subnets = ["10.0.32.0/20", "10.0.96.0/20", "10.0.160.0/20"]

vpc_azs = ["us-east-2a", "us-east-2b", "us-east-2c"]

openvpn_admin_password_secret_arn = "arn:aws:secretsmanager:us-east-2:199837183662:secret:openvpn_admin_password-beMNOa"

docker_registry = "199837183662.dkr.ecr.us-east-2.amazonaws.com"

# Jenkins
deployment_identifier = "alm"

jenkins_relay_github_secret = "IAMA_github_secret_ask_me_anything"

## Cluster variables
cluster_instance_ssh_public_key_path = "~/.ssh/id_rsa.pub"

cluster_instance_type = "t2.small"

cluster_instance_user_data_template = "templates/jenkins_instance_userdata.sh.tpl"

cluster_instance_iam_policy_contents = "files/instance_policy.json"

cluster_minimum_size = 1

cluster_maximum_size = 3

cluster_desired_capacity = 2

allowed_cidrs = ["0.0.0.0/0"]

## Load Balancer variables
service_port = 8080

domain_name = "deliveryPipeline.smartcolumbusos.com"

public_zone_id = ""

private_zone_id = ""

allow_lb_cidrs = ["0.0.0.0/0"]

include_public_dns_record = "no"

include_private_dns_record = "no"

expose_to_public_internet = "no"

## Service variables
service_task_container_definitions = "templates/task_definition.json.tpl"

attach_to_load_balancer = "yes"

memory = 1024

directory_name = "jenkins_home"

efs_encrypted = true

alm_account_id = "199837183662"
