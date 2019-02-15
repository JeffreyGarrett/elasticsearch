


module "elasticSearch" {
  source = "../../modules/aws/elasticSearch"
  
  count = 1
  tags {
      name = "${count.index}-tenant"
  }
}
