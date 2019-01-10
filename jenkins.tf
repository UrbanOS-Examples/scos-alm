data "terraform_remote_state" "durable" {
  backend   = "s3"
  workspace = "${terraform.workspace}"

  config {
    bucket   = "${var.alm_state_bucket_name}"
    key      = "alm-durable"
    region   = "us-east-2"
    role_arn = "${var.alm_role_arn}"
  }
}

locals {
  efs_dns_name = "${data.terraform_remote_state.durable.jenkins_efs_dns_name}"
  efs_id       = "${data.terraform_remote_state.durable.jenkins_efs_id}"
}

data "template_file" "instance_user_data" {
  template = "${file("templates/jenkins_instance_userdata.sh.tpl")}"

  vars {
    cluster_name   = "${module.jenkins_cluster.cluster_name}"
    mount_point    = "/efs"
    directory_name = "${local.directory_name}"

    efs_file_system_dns_name = "${local.efs_dns_name}"
    efs_file_system_id       = "${local.efs_id}"
  }
}

data "template_file" "task_definition" {
  template = "${file("templates/task_definition.json.tpl")}"

  vars {
    name           = "${local.service_name}"
    image          = "${var.docker_registry}/${local.service_image}"
    memory         = "3072"
    command        = "${jsonencode(local.service_command)}"
    jenkins_port   = "${local.jenkins_port}"
    jnlp_port      = "${local.jnlp_port}"
    region         = "${var.region}"
    log_group      = "${module.jenkins_service.log_group}"
    elb_name       = "${aws_elb.service.name}"
    directory_name = "${local.directory_name}"
    ldap_binduser_pwd = "${random_string.bind_user_password.result}"
  }
}

module "jenkins_mount_targets" {
  source  = "git@github.com:SmartColumbusOS/scos-tf-efs-mount-target"
  sg_name = "jenkins-data"
  vpc_id  = "${module.vpc.vpc_id}"
  subnet  = "${module.vpc.private_subnets[0]}"
  efs_id  = "${local.efs_id}"

  mount_target_tags = {
    "name"        = "jenkins"
    "environment" = "${var.environment}"
  }
}

resource "aws_lb_target_group" "jenkins_relay" {
  name     = "${terraform.workspace}-jenkins-relay"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"
  health_check {
    path = "/login"
    matcher = "200"
  }
}

resource "aws_route53_record" "jenkins_relay" {
  zone_id = "${aws_route53_zone.public_hosted_zone.zone_id}"
  name    = "ci-webhook"
  type    = "A"

  alias {
    name                   = "${aws_lb.jenkins_relay.dns_name}"
    zone_id                = "${aws_lb.jenkins_relay.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_lb" "jenkins_relay" {
  name     = "${terraform.workspace}-jenkins-relay"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
    "${aws_security_group.load_balancer.id}",
    "${aws_security_group.jenkins_relay.id}"
  ]
  subnets = ["${module.vpc.public_subnets}"]
}

resource "aws_security_group" "jenkins_relay" {
  name   = "${terraform.workspace}-jenkins-relay"
  vpc_id   = "${module.vpc.vpc_id}"

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "jenkins_relay" {
  load_balancer_arn = "${aws_lb.jenkins_relay.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${module.tls_certificate.arn}"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Forbidden"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "jenkins_relay" {
  listener_arn = "${aws_lb_listener.jenkins_relay.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.jenkins_relay.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/github-webhook/"]
  }
}

module "jenkins_cluster" {
  source = "github.com/SmartColumbusOS/terraform-aws-ecs-cluster-1"
  # source  = "infrablocks/ecs-cluster/aws"
  # version = "0.2.5"

  region     = "${var.region}"
  vpc_id     = "${module.vpc.vpc_id}"
  subnet_ids = "${join(",",module.vpc.private_subnets)}"

  component             = "${local.component}"
  deployment_identifier = "${terraform.workspace}"

  cluster_name                         = "${terraform.workspace}_jenkins_cluster"
  cluster_instance_ssh_public_key_path = "${var.cluster_instance_ssh_public_key_path}"
  cluster_instance_type                = "${var.cluster_instance_type}"
  cluster_instance_user_data_template  = "${data.template_file.instance_user_data.rendered}"
  cluster_instance_iam_policy_contents = "${file("files/instance_policy.json")}"
  cluster_target_group_arns            = [
    "${aws_lb_target_group.jenkins_relay.arn}"
  ]

  cluster_minimum_size     = "${var.cluster_minimum_size}"
  cluster_maximum_size     = "${var.cluster_maximum_size}"
  allowed_cidrs            = "${var.allowed_cidrs}"
}

resource "aws_route53_record" "jenkins" {
  zone_id = "${aws_route53_zone.public_hosted_zone.zone_id}"
  name    = "jenkins"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elb.service.dns_name}"]

  lifecycle {
    ignore_changes = ["name", "allow_overwrite"]
  }
}

resource "aws_elb" "service" {
  subnets = ["${module.vpc.private_subnets}"]
  security_groups = [
    "${aws_security_group.load_balancer.id}"
  ]

  internal = "true"
  name = "elb-${local.component}-${terraform.workspace}"

  cross_zone_load_balancing = true
  idle_timeout = 180
  connection_draining = true
  connection_draining_timeout = 60

  listener {
    instance_port     = "${local.jenkins_port}"
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  listener {
    instance_port      = "${local.jenkins_port}"
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${module.tls_certificate.arn}"
  }
  listener {
    instance_port     = "${local.jnlp_port}"
    instance_protocol = "tcp"
    lb_port           = "${local.jnlp_port}"
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 15
    target = "HTTP:8080/login"
    interval = 120
  }

  tags {
    Name = "elb-${local.component}-${terraform.workspace}"
    Component = "${local.component}"
    DeploymentIdentifier = "${terraform.workspace}"
    Service = "${terraform.workspace}_${local.service_name}"
  }
}

resource "aws_security_group" "load_balancer" {
  name = "elb-${local.component}-${terraform.workspace}"
  vpc_id = "${module.vpc.vpc_id}"
  description = "ELB for component: ${local.component}, service: ${terraform.workspace}_${local.service_name}, deployment: ${terraform.workspace}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.allowed_cidrs}"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["${var.allowed_cidrs}"]
  }
  ingress {
    from_port = "${local.jnlp_port}"
    to_port = "${local.jnlp_port}"
    protocol = "tcp"
    cidr_blocks = ["${var.allowed_cidrs}"]
  }

  egress {
    from_port = 1
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["${module.vpc.vpc_cidr_block}"]
  }
}

module "jenkins_service" {
  source  = "infrablocks/ecs-service/aws"
  version = "0.1.10"

  region = "${var.region}"
  vpc_id = "${module.vpc.vpc_id}"

  component             = "${local.component}"
  deployment_identifier = "${terraform.workspace}"

  service_name                       = "${local.service_name}"
  service_image                      = "${var.docker_registry}/${local.service_image}"
  service_port                       = "${local.jenkins_port}"
  service_task_container_definitions = "${data.template_file.task_definition.rendered}"

  service_desired_count                      = "1"
  service_deployment_maximum_percent         = "100"
  service_deployment_minimum_healthy_percent = "50"

  attach_to_load_balancer = "yes"
  service_elb_name        = "${aws_elb.service.name}"

  service_volumes = [
    {
      name      = "${local.directory_name}"
      host_path = "/efs/${local.directory_name}"
    },
    {
      name      = "docker-socket"
      host_path = "/var/run/docker.sock"
    },
  ]

  ecs_cluster_id               = "${module.jenkins_cluster.cluster_id}"
  ecs_cluster_service_role_arn = "${module.jenkins_cluster.service_role_arn}"
}

locals {
  component       = "delivery-pipeline"
  jenkins_port    = 8080
  jnlp_port       = 50000
  service_name    = "jenkins_master"
  service_image   = "scos/jenkins-master:a52a02a9406d9512eb56eaf4c2d695c3e8a4c127"
  service_command = []
  directory_name  = "jenkins_home"
}
variable "docker_registry" {
  description = "The URL of the docker registry"
}

variable "cluster_instance_type" {
  description = "The instance type of the container instances"
  default     = "t2.medium"
}

variable "cluster_minimum_size" {
  description = "The minimum size of the ECS cluster"
  default     = 3
}

variable "cluster_maximum_size" {
  description = "The maximum size of the ECS cluster"
  default     = 10
}
