# ec2-lambda-infra

Make a lambda to stop and start ec2 instances depending on a given name tag

# EC2 Control Lambda Function

This AWS Lambda function starts and stops EC2 instances based on their tags.

## Project Structure

ec2_control_lambda/
├── src/
│ ├── ec2_control.py
│ └── requirements.txt
├── scripts/
│ └── package_lambda.sh
├── terraform/
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
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

## Example Event

```json
{
    "action": "stop",
    "tag_name": "Name",
    "tag_value": "RowdenInstance"
}

