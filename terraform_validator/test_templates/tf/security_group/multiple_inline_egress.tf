# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}



resource "aws_security_group" "sg5" {
  name        = "sg5"
  description = "sg5"
  vpc_id      = "vpc-9f8e9dfa"

  eggress {
    from_port   = 36
    to_port     = 36
    protocol    = "tcp"
    cidr_blocks = ["1.1.1.1/32"]
  }

  egress {
    from_port       = 45
    to_port         = 45
    protocol        = "tcp"
    cidr_blocks     = ["1.2.3.4/32"]
  }
}



#{
#  "Resources": {
#    "sg5": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc2",
#        "SecurityGroupEgress" : [
#          {
#            "CidrIp" : "1.1.1.1/32",
#            "FromPort" : 36,
#            "ToPort" : 36,
#            "IpProtocol" : "tcp"
#          },
#          {
#            "CidrIp" : "1.2.3.4/32",
#            "FromPort" : 45,
#            "ToPort" : 45,
#            "IpProtocol" : "tcp"
#          }
#        ],
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    }
#  }
#}