module "security" {
  source = "git@github.com:SmartColumbusOS/scos-tf-security.git?ref=1.4.0"

  force_destroy_s3_bucket = false
  alert_handler_sns_topic_arn = "${module.monitoring.alert_handler_sns_topic_arn}"

  vpc_id = "${module.vpc.vpc_id}"
}
