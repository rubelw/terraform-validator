# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_security_group_rule" "danglingIngress" {
  type            = "ingress"
  from_port       = 45
  to_port         = 46
  protocol        = "tcp"
  cidr_blocks     = ["1.2.3.5/32"]

  security_group_id = "sg-09fb296e"
}

