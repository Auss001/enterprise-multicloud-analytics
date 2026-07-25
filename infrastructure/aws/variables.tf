variable "aws_region" {
  description = "Primary AWS deployment region."
  type        = string
  default     = "eu-north-1"
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
variable "gcp_service_account_json" {
  type        = string
  description = "Raw JSON contents of the GCP Service Account Key for BigQuery access."
  sensitive   = true
}