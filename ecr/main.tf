variable "alm_account_id" {
  description = "Account Id of the Application Life Cycle Management network"
}

variable "repository_name" {
  description = "Name of the repository to create without the prefix"
}

locals {
  policy_file = "${var.alm_account_id == "068920858268" ? "repository_policy.sandbox.json" : "repository_policy.json"}"
}

data "template_file" "repository_policy" {
  template = "${file("${path.module}/${local.policy_file}")}"

  vars {
    alm_account_id = "${var.alm_account_id}"
  }
}

resource "aws_ecr_repository" "repository" {
  name = "scos/${var.repository_name}"
}

resource "aws_ecr_repository_policy" "restore_policy" {
  repository = "${aws_ecr_repository.repository.name}"
  policy     = "${data.template_file.repository_policy.rendered}"
}
