resource "aws_db_subnet_group" "main" {
  name        = "${local.name_prefix}-database-subnet-group"
  description = "Isolated multi-AZ subnet group for Amazon RDS."

  subnet_ids = [
    aws_subnet.main["database_a"].id,
    aws_subnet.main["database_b"].id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-database-subnet-group"
      Tier = "database"
    }
  )
}