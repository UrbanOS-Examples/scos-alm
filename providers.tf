provider "null" {
  version = "~> 2.1"
}

provider "http" {
  version = "~> 1.1"
}

provider "random" {
  version = "~> 2.1"
}

provider "archive" {
  version = "~> 1.2"
}

provider "local" {
  version = "~> 1.2"
}

provider "external" {
  version = "~> 1.1"
}

provider "template" {
  version = "~> 2.1"
}

provider "aws" {
  version = "~> 3.0"
  region  = var.region

  assume_role {
    role_arn = var.alm_role_arn
  }
}

