module "proxy_cluster" {
  source = "../modules/proxy-cluster"

  region                               = "${var.region}"
  vpc_id                               = "${module.vpc.vpc_id}"
  subnet_ids                           = "${module.vpc.private_subnets}"
  deployment_identifier                = "${var.environment}"
  cluster_instance_ssh_public_key_path = "${var.cluster_instance_ssh_public_key_path}"
  allowed_cidrs                        = "${var.allowed_cidrs}"
  ui_host                              = "${var.cota_ui_host}"
  websocket_host                       = "${var.streaming_consumer_host}"
  alm_account_id                       = "${var.alm_account_id}"
}

variable "cota_ui_host" {
  description = "DNS entry or IP of the COTA UI"

  # localhost so the container doesn't blow up in sandbox env.
  default = "localhost"
}

variable "streaming_consumer_host" {
  description = "DNS entry or IP of the streaming consumer"

  # localhost so the container doesn't blow up in sandbox env.
  default = "localhost"
}

variable "alm_account_id" {
  description = "Account id of the ALM environment (should match deployment_identifier env)"
}