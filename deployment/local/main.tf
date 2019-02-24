provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.es_region}"
  version    = "~> 1.60.0"
}

/*
resource "aws_vpc" "es_VPC" {
  cidr_block = "10.0.0.0/16"

}*/

module "elasticSearch" {
  source = "../../modules/aws/elasticSearch"

  es_domain_name      = "${var.es_domain_name}"
  es_identity_pool_id = "${module.auth.es_identity_pool_id}"
  es_user_pool_id     = "${module.auth.es_user_pool_id}"
  es_cognito_role     = "${module.auth.es_cognito_rule}"

  #additional values when ready to use parameters
}

module "auth" {
  source = "../../modules/aws/auth"

  es_region      = "${var.es_region}"
  es_accountId   = "${module.elasticSearch.es_accountId}"
  es_domain_name = "${var.es_domain_name}"
  es_kibana_endpoint = "${module.elasticSearch.kibana_endpoint}"
}
