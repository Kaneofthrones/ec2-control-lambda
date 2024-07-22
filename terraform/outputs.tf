output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.ec2_control.function_name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

output "security_group_id" {
  value = aws_security_group.lambda_sg.id
}