provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
  version    = "~> 1.29.0"
}

module "elasticSearch" {
  source = "../../modules/aws/elasticSearch"

  es_domain_name = "${var.es_domain_name}"

  #additional values when ready to use parameters
}
