# Define the provider and set the region to eu-west-2 (London)
provider "aws" {
  region = "eu-west-2"
}

# Create a VPC with a CIDR block of 10.0.0.0/16
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main_vpc"
  }
}

# Create a subnet in the VPC in availability zone eu-west-2a
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "subnet_a"
  }
}

# Create another subnet in the VPC in availability zone eu-west-2b
resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "subnet_b"
  }
}

# Create a security group for the Lambda function within the VPC
resource "aws_security_group" "lambda_sg" {
  vpc_id = aws_vpc.main.id
  name   = "lambda_security_group"

  # Allow inbound HTTPS traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda_security_group"
  }
}

# Define the Lambda function
resource "aws_lambda_function" "ec2_control" {
  filename         = "${path.module}/../ec2_control_lambda.zip"
  function_name    = "ec2_control_lambda"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "ec2_control.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/../ec2_control_lambda.zip")  # Hash for version control
  runtime          = "python3.8"  # Runtime environment
  timeout          = 60  # Timeout duration in seconds

  # Configure the VPC settings for the Lambda function
  vpc_config {
    subnet_ids         = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  # Environment variables for the Lambda function
  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }
}

# Create an IAM role for the Lambda function with the necessary trust policy
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AWSLambdaBasicExecutionRole policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach the AmazonEC2FullAccess policy to the IAM role to allow EC2 actions
resource "aws_iam_role_policy_attachment" "lambda_ec2_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
