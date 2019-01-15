provider "null" {
  version = "1.0.0"
}

provider "http" {
  version = "1.0.1"
}

provider "random" {
  version = "2.0.0"
}

provider "archive" {
  version = "1.1.0"
}

provider "local" {
  version = "1.1.0"
}

provider "template" {
  version = "1.0.0"
}

provider "aws" {
  version = "1.39"
  region  = "${var.region}"

  assume_role {
    role_arn = "${var.alm_role_arn}"
  }
}
