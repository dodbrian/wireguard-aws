output "terraform_state_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "Terraform state bucket ARN"
}

output "terraform_state_lock_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the Terraform state locks DynamoDB table"
}
