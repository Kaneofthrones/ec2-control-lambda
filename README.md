# ec2-lambda-infra

Make a lambda to stop and start ec2 instances depending on a given name tag

# EC2 Control Lambda Function

This AWS Lambda function starts and stops EC2 instances based on their tags.

## Project Structure

ec2_control_lambda/
├── src/
│   ├── ec2_control.py
│   └── requirements.txt
├── scripts/
│   └── package_lambda.sh
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── README.md


## Deployment

1. **Package the Lambda Function:**

    ```bash
    bash scripts/package_lambda.sh
    ```

2. **Deploy with Terraform:**

    ```bash
    cd terraform
    terraform init
    terraform apply
    ```

## Example Event to stop an instance

```json
{
    "action": "stop",
    "tag_name": "Name",
    "tag_value": "RowdenInstance"
}
```
## Terraform plan

```terraform plan
Terraform will perform the following actions:

  # aws_iam_role.lambda_exec will be created
  + resource "aws_iam_role" "lambda_exec" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "lambda.amazonaws.com"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "lambda_exec_role"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)
    }

  # aws_iam_role_policy_attachment.lambda_basic_execution will be created
  + resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
      + role       = "lambda_exec_role"
    }

  # aws_iam_role_policy_attachment.lambda_ec2_execution will be created
  + resource "aws_iam_role_policy_attachment" "lambda_ec2_execution" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
      + role       = "lambda_exec_role"
    }

  # aws_lambda_function.ec2_control will be created
  + resource "aws_lambda_function" "ec2_control" {
      + architectures                  = (known after apply)
      + arn                            = (known after apply)
      + code_sha256                    = (known after apply)
      + filename                       = "./../ec2_control_lambda.zip"
      + function_name                  = "ec2_control_lambda"
      + handler                        = "ec2_control.lambda_handler"
      + id                             = (known after apply)
      + invoke_arn                     = (known after apply)
      + last_modified                  = (known after apply)
      + memory_size                    = 128
      + package_type                   = "Zip"
      + publish                        = false
      + qualified_arn                  = (known after apply)
      + qualified_invoke_arn           = (known after apply)
      + reserved_concurrent_executions = -1
      + role                           = (known after apply)
      + runtime                        = "python3.8"
      + signing_job_arn                = (known after apply)
      + signing_profile_version_arn    = (known after apply)
      + skip_destroy                   = false
      + source_code_hash               = "QCIEYa65xHiYnGRVyqv7JaT0AxraL7mP4AY3yevRUMc="
      + source_code_size               = (known after apply)
      + tags_all                       = (known after apply)
      + timeout                        = 60
      + version                        = (known after apply)

      + environment {
          + variables = {
              + "LOG_LEVEL" = "INFO"
            }
        }
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + lambda_function_name = "ec2_control_lambda"
```
