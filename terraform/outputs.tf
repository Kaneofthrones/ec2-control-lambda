output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.ec2_control.function_name
}

