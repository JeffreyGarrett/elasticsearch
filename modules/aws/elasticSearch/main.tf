resource "aws_elasticsearch_domain" "aula" {
  domain_name           = "aula"
  elasticsearch_version = "1.5"
  node_to_node_encryption = "true"

  encrypt_at_rest { 
      enabled = "true"
      kms_key_id = ""
  }

  ebs_options {
      ebs_enabled = "false"
      volume_type = ""
      volume_size = "100"
      iops =  ""
  }

  cluster_config {
    instance_type = "${var.es_instance_type}"
    instance_count = "${var.es_instance_count}"
    
    dedicated_master_enabled = "${var.es_dedicated_master_type}"
    dedicated_master_type = "${var.es_dedicated_master_type}"
    dedicated_master_count = "${var.ex_dedicated_master_count}" 
    zone_awareness_enabled = "${var.es_zone_awareness_enabled}"
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = {
    Domain = "TestDomain"
  }
}