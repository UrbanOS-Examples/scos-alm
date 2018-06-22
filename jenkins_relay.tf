data "template_file" "jenkins_relay_user_data" {
  template = "${file(var.jenkins_relay_user_data_template)}"

  vars {
    region         = "${var.region}"
    jenkins_host   = "${module.jenkins_ecs_load_balancer.dns_name}"
    jenkins_port   = 80
    webhook_secret = "${var.jenkins_relay_github_secret}"
    image_name     = "${var.docker_registry}/${var.jenkins_relay_docker_image}"
  }
}

resource "aws_security_group" "jenkins_relay_sg" {
  name   = "jenkins_relay_security"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 1478
    to_port     = 1478
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

resource "aws_iam_role_policy" "ecr_registry_pull" {
  name   = "ecr_registry_pull"
  policy = "${file("files/jenkins_relay_instance_policy.json")}"
  role   = "${aws_iam_role.jenkins_relay_role.name}"
}

resource "aws_iam_role" "jenkins_relay_role" {
  name = "jenkins_relay_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
              "Service": "ec2.amazonaws.com"
            },
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "jenkins_relay" {
  name = "jenkins_relay_instance_profile"
  role = "${aws_iam_role.jenkins_relay_role.name}"
}

resource "aws_instance" "jenkins_relay" {
  ami                    = "ami-922914f7"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.jenkins_relay_sg.id}"]
  subnet_id              = "${module.vpc.public_subnets[0]}"
  key_name               = "${aws_key_pair.cloud_key.key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.jenkins_relay.name}"
  user_data              = "${data.template_file.jenkins_relay_user_data.rendered}"

  tags {
    Name      = "JenkinsRelay"
    Workspace = "${terraform.workspace}"
  }
}
