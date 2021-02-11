vpc_name = "sandbox-alm"

environment = "alm"

root_dns_zone = "sandbox.internal.smartcolumbusos.com"

prod_role_arn = "arn:aws:iam::068920858268:role/admin_role"

openvpn_admin_password_secret_arn = "arn:aws:secretsmanager:us-east-2:068920858268:secret:openvpn_admin_password-8p4kVH"

vpn_ami_id = "ami-0a5aef046a3a6e7bf"

docker_registry = "068920858268.dkr.ecr.us-east-2.amazonaws.com"

cluster_instance_ssh_public_key_path = "files/oasis_id_rsa.pub"

cluster_instance_type = "t2.medium"

cluster_minimum_size = 2

cluster_maximum_size = 3

alm_role_arn = "arn:aws:iam::068920858268:role/admin_role"

alm_state_bucket_name = "scos-sandbox-terraform-state"

key_pair_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRAvH6k7iEeRDz9SQtkH1o8KiUaed/e2hmzTUjA8bhmeWVLPsgCMKIUKR0jdPlvdZ0AmMLXswobsXj08dPgWxUZxoAWIqKCjd969KckydUpBtcb+X2Q+tpOcugBOQSY1H8hgNrdcRKEaUllTfvseJ9pBOYU7j9VuZ608HQhfZw7+aS8wi9o/BJwejtpWdlo6gkxXoIRqDX/ioYg+W6Tc7yoUzAEANwZAy3/3GKWDrh+9jnzR6mEEN48Nuee49wWfP5G0T/v4+Gvux5zioHb3rcmmR9YTkFOiv1poInhXlPdc7Q38yj+z6E+hACNN3rK80YjU0ByaSPltPjqm9ZYmPX"

freeipa_replica_count = 0

kerberos_realm_name = "sandbox.internal.smartcolumbusos.com"

vpc_private_subnets = ["10.0.0.0/19", "10.0.64.0/19"]

vpc_public_subnets = ["10.0.32.0/20", "10.0.96.0/20"]

vpc_azs = ["us-east-2a", "us-east-2b"]

alarms_slack_path = "/services/T7LRETX4G/BDE8Y9SQ3/Amboqt9U8R3IYQgxUlBPkSUY"

alarms_slack_channel_name = "#pre_prod_alerts"