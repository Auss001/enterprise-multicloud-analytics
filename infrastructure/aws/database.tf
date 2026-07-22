resource "aws_db_instance" "postgresql" {
  identifier = "${local.name_prefix}-postgresql"

  engine         = "postgres"
  engine_version = "17.10"

  instance_class        = "db.t4g.micro"
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = "analytics"
  username = "platform_admin"

  manage_master_user_password = true

  port                   = 5432
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database.id]

  multi_az = false

  backup_retention_period = 7
  copy_tags_to_snapshot   = true

  auto_minor_version_upgrade = true
  apply_immediately          = true

  deletion_protection      = false
  skip_final_snapshot      = true
  delete_automated_backups = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-postgresql"
      Tier = "database"
    }
  )
}