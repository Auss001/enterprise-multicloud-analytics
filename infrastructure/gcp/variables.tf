variable "gcp_project_id" {
  type        = string
  description = "The GCP Project ID where resources will be provisioned."
  default     = "flawless-window-499104-u9"
}

variable "gcp_region" {
  type        = string
  description = "The primary GCP region for resources."
  default     = "europe-west1"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (e.g., dev, staging, prod)."
  default     = "dev"
}