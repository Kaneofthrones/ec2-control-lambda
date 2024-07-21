provider "aws" {
  region = "eu-west-2"
}

resource "aws_lambda_function" "ec2_control" {
  filename         = "${path.module}/../ec2_control_lambda.zip"
  function_name    = "ec2_control_lambda"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "ec2_control.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/../ec2_control_lambda.zip")
  runtime          = "python3.8"
  timeout          = 60

  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }
}

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

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_ec2_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

