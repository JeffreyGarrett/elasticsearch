//cognito reference

resource "aws_cognito_user_pool" "es_user_pool" {
  name             = "es_user_pool"
  alias_attributes = ["email"]

  admin_create_user_config = {
    allow_admin_create_user_only = true
  }
}

resource "aws_cognito_user_pool_domain" "es_user_pool_domain" {
  domain       = "esauladomain"
  user_pool_id = "${aws_cognito_user_pool.es_user_pool.id}"
}

resource "aws_cognito_user_pool_client" "es_user_pool_client" {
  name = "es_user_pool_client"

  user_pool_id = "${aws_cognito_user_pool.es_user_pool.id}"

  generate_secret     = true
  explicit_auth_flows = ["USER_PASSWORD_AUTH"]

  //callback_urls = ["${var.es_kibana_endpoint}"]
  // supported_identity_providers = ["cognito_user_pool"]
}

resource "aws_cognito_identity_pool" "es_identity_pool" {
  identity_pool_name               = "es_identity_pool"
  allow_unauthenticated_identities = true

  cognito_identity_providers {
    provider_name           = "${aws_cognito_user_pool.es_user_pool.endpoint}"
    server_side_token_check = false
    client_id               = "${aws_cognito_user_pool_client.es_user_pool_client.id}"
  }
}

resource "aws_cognito_user_group" "es_user_group" {
  name         = "es_user_group"
  user_pool_id = "${aws_cognito_user_pool.es_user_pool.id}"
  description  = "permission to ES stack"
  role_arn     = "${aws_iam_role.es_admin_iam_role.arn}"
}

resource "aws_cognito_identity_pool_roles_attachment" "es_identity_pool_roles" {
  identity_pool_id = "${aws_cognito_identity_pool.es_identity_pool.id}"

  roles = {
    "authenticated" = "${aws_iam_role.es_cognito_role.arn}"
  }
}

resource "aws_iam_role" "es_admin_iam_role" {
  name               = "es_admin_iam_role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.es_admin_iam_policy_document.json}"
}

resource "aws_iam_role_policy" "es_admin_iam_policy" {
  name = "es_admin_iam_policy"
  role = "${aws_iam_role.es_admin_iam_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "es:*",
        "mobileanalytics:PutEvents",
        "cognito-sync:*",
        "cognito-identity:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "es_admin_iam_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "es_cognito_role" {
  name = "es_cognito_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "es_cognito_role_policy" {
  name = "es_cognito_role_policy"
  role = "${aws_iam_role.es_cognito_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cognito-idp:DescribeUserPool",
                "cognito-idp:CreateUserPoolClient",
                "cognito-idp:DeleteUserPoolClient",
                "cognito-idp:DescribeUserPoolClient",
                "cognito-idp:AdminInitiateAuth",
                "cognito-idp:AdminUserGlobalSignOut",
                "cognito-idp:ListUserPoolClients",
                "cognito-identity:DescribeIdentityPool",
                "cognito-identity:UpdateIdentityPool",
                "cognito-identity:SetIdentityPoolRoles",
                "cognito-identity:GetIdentityPoolRoles",
                "iam:GetRole",
                "iam:PassRole",
                "iam:CreateRole",
                "iam:AttachRolePolicy",
                "ec2:DescribeVpcs",
                "cognito-identity:ListIdentityPools",
                "cognito-idp:ListUserPools",
                "AmazonCognitoIdentity:*",
                "es:*"
                ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "iam:PassedToService": "cognito-identity.amazonaws.com"
                }
            }
        }
    ]
}
EOF
}

output "es_user_pool_id" {
  value = "${aws_cognito_user_pool.es_user_pool.id}"
}

output "es_identity_pool_id" {
  value = "${aws_cognito_identity_pool.es_identity_pool.id}"
}

output "es_cognito_rule" {
  value = "${aws_iam_role.es_cognito_role.arn}"
}
