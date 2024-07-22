provider "aws" {
  region = var.region
}

# Retrieve the latest Amazon Linux 2 AMI ID from AWS Systems Manager Parameter Store
data "aws_ssm_parameter" "latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Import VPC outputs from the VPC configuration
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket         = "km-rowden-terraform-state-bucket"
    key            = "terraform/state"
    region         = "eu-west-2"
    dynamodb_table = "km-rowden-terraform-lock-table"
    encrypt        = true
  }
}

resource "aws_instance" "rowden_instance" {
  ami           = data.aws_ssm_parameter.latest_ami.value
  instance_type = var.instance_type
  subnet_id     = element(data.terraform_remote_state.vpc.outputs.subnet_ids, 0)

  tags = {
    Name = "Rowden"
  }

  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.security_group_id]
}