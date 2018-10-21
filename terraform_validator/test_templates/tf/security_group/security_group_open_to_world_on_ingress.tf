# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}



resource "aws_security_group" "sgOpenIngress" {
  name        = "sgOpenIngress"
  description = "sgOpenIngress"
  vpc_id      = "vpc-9f8e9dfa"

  ingress {
    from_port   = 34
    to_port     = 34
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "sgOpenIngress2" {
  name        = "sgOpenIngress2"
  description = "sgOpenIngress2"
  vpc_id      = "vpc-9f8e9dfa"

}


resource "aws_security_group_rule" "securityGroupIngress" {
  type            = "ingress"
  from_port       = 46
  to_port         = 46
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.sgOpenIngress2.id}"
}



#{
#  "Resources": {
#    "sgOpenIngress": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc",
#        "SecurityGroupIngress" : {
#          "CidrIp": "0.0.0.0/0",
#          "FromPort": 34,
#          "ToPort": 34,
#          "IpProtocol": "tcp"
#        },
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    },

#    "sgOpenIngress2": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc",
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    },

#    "securityGroupIngress" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sgOpenIngress2"
#        },
#        "CidrIp" : "0.0.0.0/0",
#        "FromPort" : 46,
#        "ToPort" : 46,
#        "IpProtocol" : "tcp"
#      }
#    }
#  }
#}