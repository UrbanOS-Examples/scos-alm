module "security" {
  source = "git@github.com:SmartColumbusOS/scos-tf-security.git?ref=1.0.2"

  force_destroy_s3_bucket = false
}
