module "monitoring" {
  source = "git@github.com:SmartColumbusOS/scos-tf-monitoring.git?ref=1.0.1"

  alarms_slack_channel_name = "${var.alarms_slack_channel_name}"
  alarms_slack_path         = "${var.alarms_slack_path}"
}

variable "alarms_slack_path" {
  description = "Path to the Slack channel for monitoring alarms"
}

variable "alarms_slack_channel_name" {
  description = "Name of the Slack channel for monitoring alarms"
}