variable "aws_region" {
  description = "Primary AWS deployment region."
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project name."
  type        = string
  default     = "enterprise-multicloud-analytics"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR."
  type        = string
  default     = "10.20.0.0/16"
}
