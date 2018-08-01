data "template_file" "jenkins_relay_user_data" {
  template = "${file(var.jenkins_relay_user_data_template)}"

  vars {
    jenkins_host = "${module.jenkins_ecs_load_balancer.dns_name}"
    jenkins_port = 80
    dns_name     = "ci-webhook.${var.environment}.${var.root_dns_name}"
  }
}

resource "aws_security_group" "jenkins_relay_sg" {
  name   = "jenkins_relay_security"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "jenkins_relay_sg"
  }
}

resource "aws_route53_record" "github-webhook" {
  zone_id = "${aws_route53_zone.public_hosted_zone.zone_id}"
  name    = "ci-webhook.${var.environment}.${var.root_dns_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.jenkins_relay.public_ip}"]
}

resource "aws_route53_record" "github-webhook_private" {
  zone_id = "${aws_route53_zone.private_hosted_zone.zone_id}"
  name    = "ci-webhook.${var.environment}.${var.root_dns_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.jenkins_relay.public_ip}"]
}

resource "aws_instance" "jenkins_relay" {
  ami                    = "ami-04370661"
  instance_type          = "t2.nano"
  vpc_security_group_ids = ["${aws_security_group.jenkins_relay_sg.id}"]
  subnet_id              = "${module.vpc.public_subnets[0]}"
  key_name               = "${aws_key_pair.cloud_key.key_name}"
  user_data              = "${data.template_file.jenkins_relay_user_data.rendered}"

  tags {
    Name      = "JenkinsRelay"
    Workspace = "${terraform.workspace}"
  }
}

variable "jenkins_relay_github_secret" {
  description = "Secret token for jenkins api access"
  default     = "IAMA_github_secret_ask_me_anything"
}
