module "joomla_restore_repository" {
  source = "ecr"

  alm_account_id  = "${var.alm_account_id}"
  repository_name = "joomla-restore"
}

module "joomla_cron_repository" {
  source = "ecr"

  alm_account_id  = "${var.alm_account_id}"
  repository_name = "joomla-cron"
}

module "joomla_nginx_repository" {
  source = "ecr"

  alm_account_id  = "${var.alm_account_id}"
  repository_name = "joomla-nginx"
}
