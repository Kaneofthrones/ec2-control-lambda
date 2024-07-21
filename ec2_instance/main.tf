provider "aws" {
  region = var.region
}

resource "aws_instance" "rowden_instance" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "Rowden"
  }
}

