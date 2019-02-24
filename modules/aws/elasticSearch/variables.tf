variable "es_domain_name" {
  description = "elasticSearch domain name"
  type        = "string"
}

variable "es_version" {
  description = "Version of elasticsearch we will be using"
  type        = "string"
  default     = "6.4"
}

variable "es_node_encryption" {
  description = "set to false to disable encryption in transit"
  type        = "string"
  default     = "true"
}

variable "es_encrypt_at_rest" {
  default = "true"
}

variable "es_kms_key_id" {
  description = "required if using ebs volumes"
  default     = ""
}

variable "es_instance_type" {
  description = "instance size of the es cluster"
  type        = "string"
  default     = "r4.large.elasticsearch"
}

variable "es_instance_count" {
  description = "number of instances of nodes"
  default     = "1"
}

#group together
variable "es_dedicated_master_enabled" {
  description = "enable dedicated masters"
  default     = "false"
}

variable "es_dedicated_master_type" {
  description = "if enabling master, type of master instance"
  default     = ""
}

variable "es_dedicated_master_count" {
  description = "number of master nodes"
  default     = "0"
}

variable "es_zone_awareness_enabled" {
  description = "zone awareness"
  default     = "false"
}

###

variable "es_security_group_ids" {
  description = "description"
  type        = "list"
  default     = []
}

#required with vpc
variable "es_subnet_id" {
  description = "subnet id of VPC"
  default     = ""
  type        = "string"
}

#log_publishing_options
variable "es_log_enabled" {
  description = "description"
  default     = "false"
  type        = "string"
}

variable es_log_type {
  description = "log type of to publish"
  default     = ""
  type        = "string"
}

variable "es_identity_pool_id" {
  description = "identity pool for kibana access"
  type        = "string"
}

variable "es_user_pool_id" {
  description = "es user pool id for kibana access"
}

variable "es_cognito_role" {
  description = "the cognito role for es that allows access through cognito"
}
