provider "aws" {
  region = var.region
}

# Retrieve the latest Amazon Linux 2 AMI ID from AWS Systems Manager Parameter Store
data "aws_ssm_parameter" "latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "rowden_instance" {
  ami           = data.aws_ssm_parameter.latest_ami.value
  instance_type = var.instance_type

  tags = {
    Name = "Rowden"
  }
}
