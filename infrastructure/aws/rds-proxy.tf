data "aws_iam_policy_document" "rds_proxy_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "rds_proxy" {
  name               = "${local.name_prefix}-rds-proxy-role"
  assume_role_policy = data.aws_iam_policy_document.rds_proxy_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rds-proxy-role"
      Tier = "database"
    }
  )
}

data "aws_iam_policy_document" "rds_proxy_secret_access" {
  statement {
    sid    = "ReadDatabaseSecret"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      aws_db_instance.postgresql.master_user_secret[0].secret_arn
    ]
  }
}

resource "aws_iam_role_policy" "rds_proxy_secret_access" {
  name   = "${local.name_prefix}-rds-proxy-secret-access"
  role   = aws_iam_role.rds_proxy.id
  policy = data.aws_iam_policy_document.rds_proxy_secret_access.json
}

resource "aws_db_proxy" "postgresql" {
  name                   = "${local.name_prefix}-postgresql-proxy"
  engine_family          = "POSTGRESQL"
  role_arn               = aws_iam_role.rds_proxy.arn
  require_tls            = true
  idle_client_timeout    = 1800
  debug_logging          = false
  vpc_security_group_ids = [aws_security_group.rds_proxy.id]

  vpc_subnet_ids = [
    aws_subnet.main["application_a"].id,
    aws_subnet.main["application_b"].id
  ]


  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = aws_db_instance.postgresql.master_user_secret[0].secret_arn
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-postgresql-proxy"
      Tier = "database"
    }
  )

  depends_on = [
    aws_iam_role_policy.rds_proxy_secret_access
  ]
}

resource "aws_db_proxy_default_target_group" "postgresql" {
  db_proxy_name = aws_db_proxy.postgresql.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 80
    max_idle_connections_percent = 40
  }
}

resource "aws_db_proxy_target" "postgresql" {
  db_instance_identifier = aws_db_instance.postgresql.identifier
  db_proxy_name          = aws_db_proxy.postgresql.name
  target_group_name      = aws_db_proxy_default_target_group.postgresql.name

  lifecycle {
    replace_triggered_by = [
      aws_db_proxy.postgresql.id
    ]
  }
}
