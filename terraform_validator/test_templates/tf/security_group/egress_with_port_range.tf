# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


variable "aws_access_key" {
  type = "string"
  default = "xx"

}

variable "aws_secret_key" {
  type = "string"
  default = "xx"
}

resource "aws_security_group" "some_group_desc" {
  name        = "some_group_desc"
  description = "some_group_desc"
  vpc_id      = "vpc-9f8e9dfa"

  egress {
    from_port       = 34
    to_port         = 36
    protocol        = "tcp"
    cidr_blocks     = ["10.1.2.3/32"]
  }
}


resource "aws_security_group_rule" "securityGroupEgress" {
  type            = "egress"
  from_port       = 41
  to_port         = 45
  protocol        = "tcp"
  cidr_blocks     = ["1.1.1.1/32"]

  security_group_id = "sg-12341234"
}

