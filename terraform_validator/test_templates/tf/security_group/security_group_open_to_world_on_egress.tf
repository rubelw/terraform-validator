# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}



resource "aws_security_group" "sgOpenEgress" {
  name        = "sgOpenEgress"
  description = "sgOpenEgress"
  vpc_id      = "vpc-9f8e9dfa"

  egress {
    from_port       = 34
    to_port         = 34
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "sgOpenEgress2" {
  name        = "sgOpenEgress2"
  description = "sgOpenEgress2"
  vpc_id      = "vpc-9f8e9dfa"

}


resource "aws_security_group_rule" "securityGroupEgress" {
  type            = "egress"
  from_port       = 46
  to_port         = 46
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.sgOpenEgress2.id}"
}


#{
#  "Resources": {
#    "sgOpenEgress": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc",
#        "SecurityGroupEgress" : {
#          "CidrIp": "0.0.0.0/0",
#          "FromPort": 34,
#          "ToPort": 34,
#          "IpProtocol": "tcp"
#        },
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    },

#    "sgOpenEgress2": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc",
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    },

#    "securityGroupEgress" : {
#      "Type" : "AWS::EC2::SecurityGroupEgress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sgOpenEgress2"
#        },
#        "CidrIp" : "0.0.0.0/0",
#        "FromPort" : 46,
#        "ToPort" : 46,
#        "IpProtocol" : "tcp"
#      }
#    }
#  }
#}