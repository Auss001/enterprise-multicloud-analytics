locals {
  name_prefix = "ema-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  subnets = {
    public_a = {
      cidr                     = "10.20.0.0/24"
      availability_zone_offset = 0
      tier                     = "public"
      map_public_ip            = true
    }

    public_b = {
      cidr                     = "10.20.1.0/24"
      availability_zone_offset = 1
      tier                     = "public"
      map_public_ip            = true
    }

    application_a = {
      cidr                     = "10.20.10.0/24"
      availability_zone_offset = 0
      tier                     = "application"
      map_public_ip            = false
    }

    application_b = {
      cidr                     = "10.20.11.0/24"
      availability_zone_offset = 1
      tier                     = "application"
      map_public_ip            = false
    }

    database_a = {
      cidr                     = "10.20.20.0/24"
      availability_zone_offset = 0
      tier                     = "database"
      map_public_ip            = false
    }

    database_b = {
      cidr                     = "10.20.21.0/24"
      availability_zone_offset = 1
      tier                     = "database"
      map_public_ip            = false
    }
  }
}