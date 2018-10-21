# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


variable somethingSpecial {
  type = "string"
  default = "test"
}


resource "aws_security_group" "sgDualModel" {
  name        = "sgDualModel"
  description = "sgDualModel"
  vpc_id      = "vpc-9f8e9dfa"

  egress {
    from_port       = 34
    to_port         = 34
    protocol        = "tcp"
    cidr_blocks     = ["10.1.2.3/32"]
  }
}

resource "aws_security_group_rule" "securityGroupIngress5" {
  type            = "ingress"
  from_port       = 45
  to_port         = 46
  protocol        = "tcp"
  cidr_blocks     = ["1.2.3.5/32"]

  security_group_id = "${aws_security_group.sgDualModel.id}"
}


resource "aws_security_group_rule" "securityGroupIngressIp6" {
  type            = "ingress"
  from_port       = 45
  to_port         = 46
  protocol        = "tcp"
  ipv6_cidr_blocks     = ["2001::/64"]

  security_group_id = "${aws_security_group.sgDualModel.id}"
}

resource "aws_security_group_rule" "securityGroupIngress" {
  type            = "ingress"
  from_port       = 45
  to_port         = 45
  protocol        = "tcp"
  ipv6_cidr_blocks     = ["2001::/99"]

  security_group_id = "sg-12341234"
}


#{
#  "Parameters": {
#    "somethingSpecial": {
#      "Type": "String"
#    }
#  },
#
#  "Resources": {
#    "sgDualModel": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc",
#        "VpcId" : "vpc-9f8e9dfa",
#        "SecurityGroupEgress" : {
#          "CidrIp": "10.1.2.3/32",
#          "FromPort": 34,
#          "ToPort": 34,
#          "IpProtocol": "tcp"
#        }
#      }
#    },

#    "securityGroupIngress5" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sgDualModel"
#        },
#        "CidrIp" :  "1.2.3.4/32",
#        "FromPort" : 46,
#        "ToPort" : 46,
#        "IpProtocol" : "tcp"
#      }
#    },

#    "securityGroupIngressIp6" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sgDualModel"
#        },
#        "CidrIpv6" :  "2001::/64",
#        "FromPort" : 46,
#        "ToPort" : 46,
#        "IpProtocol" : "tcp"
#      }
#    },

#    "securityGroupIngress" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": "sg-12341234",
#        "CidrIpv6" : "2001::/99",
#        "FromPort" : 45,
#        "ToPort" : 45,
#        "IpProtocol" : "tcp"
#      }
#    }
#  }
#}