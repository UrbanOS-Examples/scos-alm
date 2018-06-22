data "template_file" "cota_proxy_definition" {
  template = "${file("proxy-cluster/cota.json")}"

  vars {
    ui_host        = "${var.ui_host}"
    websocket_host = "${var.websocket_host}"
    alm_account_id = "${var.alm_account_id}"
  }
}

resource "aws_ecs_task_definition" "cota-proxy" {
  family                = "cota-proxy"
  container_definitions = "${data.template_file.cota_proxy_definition.rendered}"
}

resource "aws_ecs_service" "cota-proxy" {
  name = "cota-proxy"

  # The cluster name is calculated by the infrablocks module and is not the same as the *input* cluster_name.
  cluster         = "${module.proxy_cluster.cluster_name}"
  task_definition = "${aws_ecs_task_definition.cota-proxy.arn}"
  desired_count   = 1

  depends_on = ["module.proxy_cluster"]
}

# I don't like this module we're using here and for the Jenkins cluster.
# It uses a sleep instead of properly resolving its resource dependency graph.
# We should consider creating the cluster from scratch ourselves.
module "proxy_cluster" {
  source  = "infrablocks/ecs-cluster/aws"
  version = "0.2.5"

  region     = "${var.region}"
  vpc_id     = "${var.vpc_id}"
  subnet_ids = "${join(",",var.subnet_ids)}"

  component             = "proxies"
  deployment_identifier = "${var.deployment_identifier}"

  cluster_name                         = "proxies"
  cluster_instance_ssh_public_key_path = "${var.cluster_instance_ssh_public_key_path}"
  cluster_instance_type                = "t2.nano"
  cluster_instance_iam_policy_contents = "${file("proxy-cluster/instance_policy.json")}"

  # in order to update running containers, we need at least 2 instances
  cluster_minimum_size     = "3"
  cluster_maximum_size     = "3"
  cluster_desired_capacity = "3"
  allowed_cidrs            = "${var.allowed_cidrs}"
}
