output "dynamoDB-ARN" {
    description="ARN of the dynamoDB table created"
    value= aws_dynamodb_table.terraform_locks.arn
}

output "state-bucket-arn" {
  description = "ARN of the s3 bucket for remote state"
  value = aws_s3_bucket.terraform_state.arn
}
