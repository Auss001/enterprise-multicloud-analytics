output "vpc_id" {
  description = "ID of the platform VPC."
  value       = aws_vpc.main.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = aws_internet_gateway.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value = [
    for key, subnet in aws_subnet.main :
    subnet.id
    if local.subnets[key].tier == "public"
  ]
}

output "application_subnet_ids" {
  description = "IDs of the private application subnets."
  value = [
    for key, subnet in aws_subnet.main :
    subnet.id
    if local.subnets[key].tier == "application"
  ]
}

output "database_subnet_ids" {
  description = "IDs of the isolated database subnets."
  value = [
    for key, subnet in aws_subnet.main :
    subnet.id
    if local.subnets[key].tier == "database"
  ]
}

output "subnet_details" {
  description = "Subnet names, IDs, CIDR blocks, tiers and Availability Zones."
  value = {
    for key, subnet in aws_subnet.main :
    key => {
      id                = subnet.id
      cidr              = subnet.cidr_block
      availability_zone = subnet.availability_zone
      tier              = local.subnets[key].tier
    }
  }
}
output "application_security_group_id" {
  description = "Security group ID for application workloads."
  value       = aws_security_group.application.id
}

output "rds_proxy_security_group_id" {
  description = "Security group ID for RDS Proxy."
  value       = aws_security_group.rds_proxy.id
}

output "database_security_group_id" {
  description = "Security group ID for PostgreSQL."
  value       = aws_security_group.database.id
}

output "database_subnet_group_name" {
  description = "Name of the RDS database subnet group."
  value       = aws_db_subnet_group.main.name
}
output "database_endpoint" {
  description = "Private DNS endpoint of the PostgreSQL database."
  value       = aws_db_instance.postgresql.address
}

output "database_port" {
  description = "PostgreSQL connection port."
  value       = aws_db_instance.postgresql.port
}

output "database_master_secret_arn" {
  description = "ARN of the RDS-managed Secrets Manager secret."
  value       = aws_db_instance.postgresql.master_user_secret[0].secret_arn
}