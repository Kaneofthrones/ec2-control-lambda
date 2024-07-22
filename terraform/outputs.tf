output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.ec2_control.function_name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
}

output "security_group_id" {
  value = aws_security_group.lambda_sg.id
}