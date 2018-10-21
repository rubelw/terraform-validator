# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}



resource "aws_security_group" "sg" {
  name        = "sg"
  description = "sg"
  vpc_id      = "vpc-9f8e9dfa"


  egress {
    from_port       = 34
    to_port         = 36
    protocol        = "tcp"
    cidr_blocks     = ["10.1.2.3/32"]
  }
}


#{
#  "Resources": {
#    "sg": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc",
#        "SecurityGroupEgress" : {
#          "CidrIp": "10.1.2.3/32",
#          "FromPort": 34,
#          "ToPort": 36,
#          "IpProtocol": "tcp"
#        },
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    }
#  }
#}