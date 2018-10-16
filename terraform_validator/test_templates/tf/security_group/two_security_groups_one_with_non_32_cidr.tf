# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_security_group" "some_group_desc" {
  name        = "some_group_desc"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-9f8e9dfa"

  ingress {
    from_port   = 34
    to_port     = 36
    protocol    = "tcp"
    cidr_blocks = ["10.1.2.3/32"]
  }

}


resource "aws_security_group" "some_group_desc2" {
  name        = "some_group_desc2"
  description = "some_group_desc2"
  vpc_id      = "vpc-9f8e9dfa"
  ingress {
    from_port   = 45
    to_port     = 46
    protocol    = "tcp"
    cidr_blocks = ["1.2.3.4/24"]
  }

  tags {
    Name = "allow_all"
  }
}
