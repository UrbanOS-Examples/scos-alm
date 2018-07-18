vpc_name = "alm"

environment = "alm"

credentials_profile = "jenkins"

openvpn_admin_password_secret_arn = "arn:aws:secretsmanager:us-east-2:199837183662:secret:openvpn_admin_password-beMNOa"

vpc_private_subnets = ["10.0.0.0/19", "10.0.64.0/19", "10.0.128.0/19"]

vpc_public_subnets = ["10.0.32.0/20", "10.0.96.0/20", "10.0.160.0/20"]

vpc_azs = ["us-east-2a", "us-east-2b", "us-east-2c"]

docker_registry = "199837183662.dkr.ecr.us-east-2.amazonaws.com"

cluster_instance_ssh_public_key_path = "files/oasis_id_rsa.pub"
cluster6_instance_ssh_public_key_path = "files/oasis6_id_rsa.pub"

cluster_instance_type = "t2.small"

cluster_minimum_size = 1

cluster_maximum_size = 3

cluster_desired_capacity = 2

domain_name = "deliveryPipeline.smartcolumbusos.com"

alm_account_id = "199837183662"

key_pair_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRAvH6k7iEeRDz9SQtkH1o8KiUaed/e2hmzTUjA8bhmeWVLPsgCMKIUKR0jdPlvdZ0AmMLXswobsXj08dPgWxUZxoAWIqKCjd969KckydUpBtcb+X2Q+tpOcugBOQSY1H8hgNrdcRKEaUllTfvseJ9pBOYU7j9VuZ608HQhfZw7+aS8wi9o/BJwejtpWdlo6gkxXoIRqDX/ioYg+W6Tc7yoUzAEANwZAy3/3GKWDrh+9jnzR6mEEN48Nuee49wWfP5G0T/v4+Gvux5zioHb3rcmmR9YTkFOiv1poInhXlPdc7Q38yj+z6E+hACNN3rK80YjU0ByaSPltPjqm9ZYmPX"
