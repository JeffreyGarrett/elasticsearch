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

    dedicated_master_enabled = "${var.es_dedicated_master_enabled}"
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
  
  cognito_options {
    enabled = true
    user_pool_id = "${var.es_user_pool_id}"
    identity_pool_id = "${var.es_identity_pool_id}"
    role_arn = "${var.es_cognito_role}" 
  }

  tags {
    Domain = "aula"
  }
}

resource "aws_elasticsearch_domain_policy" "es_domain_policy" {
  domain_name = "${aws_elasticsearch_domain.aula.domain_name}"

  access_policies = <<POLICIES
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "575765758672"
        ]
      },
      "Action": [
        "es:*"
      ],
      "Resource": "arn:aws:es:us-east-1:575765758672:domain/jefftestaula/*"
    }
  ]
}
POLICIES
}

output "es_accountId" {
  value = "${aws_elasticsearch_domain.aula.domain_id}"
}

output "kibana_endpoint" {
  value = "${aws_elasticsearch_domain.aula.kibana_endpoint}"
}

