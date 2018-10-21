# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

variable test {
  type = "string"
  default = "test"
}

resource "aws_security_group_rule" "securityGroupEgress2" {
  type            = "egress"
  from_port       = 45
  to_port         = 46
  protocol        = "tcp"
  cidr_blocks     = ["1.2.3.5/32"]

  security_group_id = "${var.test}"
}

