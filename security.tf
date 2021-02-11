module "security" {
  source = "git@github.com:SmartColumbusOS/scos-tf-security.git?ref=common-512"

  force_destroy_s3_bucket     = false
  alert_handler_sns_topic_arn = module.monitoring.alert_handler_sns_topic_arn

  default_network_acl_id = module.vpc.default_network_acl_id
}

