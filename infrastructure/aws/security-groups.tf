# Application/Lambda security group
resource "aws_security_group" "application" {
  name        = "${local.name_prefix}-application-sg"
  description = "Controls network traffic for application workloads."
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-application-sg"
      Tier = "application"
    }
  )
}
resource "aws_vpc_security_group_egress_rule" "application_all_outbound" {
  security_group_id = aws_security_group.application.id

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}



# RDS Proxy security group
resource "aws_security_group" "rds_proxy" {
  name        = "${local.name_prefix}-rds-proxy-sg"
  description = "Allows PostgreSQL connections from the application layer."
  vpc_id      = aws_vpc.main.id

  ingress = []
  egress  = []

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rds-proxy-sg"
      Tier = "database-proxy"
    }
  )
}

# PostgreSQL database security group
resource "aws_security_group" "database" {
  name        = "${local.name_prefix}-database-sg"
  description = "Allows PostgreSQL connections only from RDS Proxy."
  vpc_id      = aws_vpc.main.id

  ingress = []
  egress  = []

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-database-sg"
      Tier = "database"
    }
  )
}

# Application can connect only to RDS Proxy on PostgreSQL port 5432
resource "aws_vpc_security_group_egress_rule" "application_to_rds_proxy" {
  security_group_id            = aws_security_group.application.id
  referenced_security_group_id = aws_security_group.rds_proxy.id

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432

  description = "Allow application workloads to connect to RDS Proxy."
}

# RDS Proxy accepts PostgreSQL traffic only from the application security group
resource "aws_vpc_security_group_ingress_rule" "rds_proxy_from_application" {
  security_group_id            = aws_security_group.rds_proxy.id
  referenced_security_group_id = aws_security_group.application.id

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432

  description = "Allow PostgreSQL traffic from application workloads."
}

# RDS Proxy can connect only to the database
resource "aws_vpc_security_group_egress_rule" "rds_proxy_to_database" {
  security_group_id            = aws_security_group.rds_proxy.id
  referenced_security_group_id = aws_security_group.database.id

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432

  description = "Allow RDS Proxy to connect to PostgreSQL."
}

# Database accepts PostgreSQL traffic only from RDS Proxy
resource "aws_vpc_security_group_ingress_rule" "database_from_rds_proxy" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = aws_security_group.rds_proxy.id

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432

  description = "Allow PostgreSQL traffic from RDS Proxy."
}

# Application workloads can reach AWS services over HTTPS
resource "aws_vpc_security_group_egress_rule" "application_https_outbound" {
  security_group_id = aws_security_group.application.id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_ipv4   = "0.0.0.0/0"

  description = "Allow application workloads to reach AWS services over HTTPS."
}