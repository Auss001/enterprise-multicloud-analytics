output "state_bucket_name" {
  description = "Terraform state bucket name."
  value       = aws_s3_bucket.terraform_state.id
}

output "aws_account_id" {
  description = "AWS account containing the state bucket."
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS region containing the state bucket."
  value       = var.aws_region
}
