# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}



resource "aws_security_group" "sg2" {
  name        = "sg2"
  description = "sg2"
  vpc_id      = "vpc-9f8e9dfa"
}


resource "aws_security_group_rule" "securityGroupEgress" {
  type            = "egress"
  from_port       = 45
  to_port         = 46
  protocol        = "tcp"
  cidr_blocks     = ["1.2.3.4/32"]

  security_group_id = "${aws_security_group.sg2.id}"
}

resource "aws_security_group_rule" "securityGroupEgress2" {
  type            = "egress"
  from_port       = 45
  to_port         = 46
  protocol        = "tcp"
  cidr_blocks     = ["1.2.3.5/32"]

  security_group_id = "${aws_security_group.sg2.id}"
}


#{
#  "Resources": {
#    "sg2": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc2",
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    },

#    "securityGroupEgress" : {
#      "Type" : "AWS::EC2::SecurityGroupEgress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sg2"
#        },
#        "CidrIp" : "1.2.3.4/32",
#        "FromPort" : 45,
#        "ToPort" : 46,
#        "IpProtocol" : "tcp"
#      }
#    },

#    "securityGroupEgress2" : {
#      "Type" : "AWS::EC2::SecurityGroupEgress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sg2"
#        },
#        "CidrIp" : "1.2.3.5/32",
#        "FromPort" : 45,
#        "ToPort" : 46,
#        "IpProtocol" : "tcp"
#      }
#    }
#  }
#}