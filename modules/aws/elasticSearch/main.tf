
resource "aws_elasticsearch_domain" "aula" {
  domain_name           = "${var.es_domain_name}"
  elasticsearch_version = "${var.es_version}"
/*
  node_to_node_encryption {
    enabled = "${var.es_node_encryption}"
  }
*/
  encrypt_at_rest {
    enabled    = "${var.es_encrypt_at_rest}"
    kms_key_id = "${var.es_kms_key_id}"
  }

  ebs_options {
    ebs_enabled = "true"
    volume_type = "standard"
    volume_size = 40
  }

  cluster_config {
    instance_type  = "${var.es_instance_type}"
    instance_count = "${var.es_instance_count}"

    dedicated_master_enabled = "${var.es_dedicated_master_type}"
    dedicated_master_type    = "${var.es_dedicated_master_type}"
    dedicated_master_count   = "${var.es_dedicated_master_count}"
    zone_awareness_enabled   = "${var.es_zone_awareness_enabled}"
  }
/*
  vpc_options {
    security_group_ids = ["${var.es_security_group_ids}"]
    subnet_ids         = ["${var.es_subnet_id}"]
  }

  log_publishing_options {
    log_type                 = "${var.es_log_type}"
    cloudwatch_log_group_arn = "${var.es_cloudwatch_log_group_arn}"
    enabled                  = "${var.es_log_enabled}"
  }
*/
  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags {
    Domain = "aula"
  }
}
