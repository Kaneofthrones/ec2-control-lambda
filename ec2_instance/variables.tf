variable "region" {
  description = "The AWS region to deploy in"
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "The type of instance to deploy"
  default     = "t2.micro"
}

variable "ami" {
  description = "The Amazon Machine Image (AMI) ID"
  default     = "ami-0c55b159cbfafe1f0"
}

