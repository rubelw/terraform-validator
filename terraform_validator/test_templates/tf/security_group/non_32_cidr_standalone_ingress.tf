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


resource "aws_security_group" "sg" {
  name        = "sg"
  description = "sg"
  vpc_id      = "vpc-9f8e9dfa"

  egress {
    from_port       = 34
    to_port         = 34
    protocol        = "tcp"
    cidr_blocks     = ["10.1.2.3/32"]
  }
}


resource "aws_security_group_rule" "securityGroupIngress1" {
  type            = "ingress"
  from_port       = 36
  to_port         = 66
  protocol        = "tcp"
  cidr_blocks     = ["10.1.2.3/32"]

  security_group_id = "${aws_security_group.sg.id}"
}


resource "aws_security_group_rule" "securityGroupIngress2" {
  type            = "ingress"
  from_port       = 36
  to_port         = 66
  protocol        = "tcp"
  cidr_blocks     = ["10.1.2.3/32",,"3.4.5.6/24"]

  security_group_id = "${aws_security_group.sg.id}"
}


resource "aws_security_group_rule" "securityGroupIngress3" {
  type            = "ingress"
  from_port       = 46
  to_port         = 46
  protocol        = "tcp"
  cidr_blocks     = ["10.1.2.3/24"]

  security_group_id = "${aws_security_group.sg.id}"
}


resource "aws_security_group_rule" "securityGroupIngress4" {
  type            = "ingress"
  from_port       = 46
  to_port         = 46
  protocol        = "tcp"
  cidr_blocks     = ["${var.somethingSpecial}"]

  security_group_id = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "securityGroupIngress5" {
  type            = "ingress"
  from_port       = 46
  to_port         = 46
  protocol        = "tcp"
  cidr_blocks     = ["10.1.2.3/32", "${var.somethingSpecial}"]

  security_group_id = "${aws_security_group.sg.id}"
}


#{
#  "Parameters": {
#    "somethingSpecial": {
#      "Type": "String"
#    }
#  },
#
#  "Resources": {
#    "sg": {
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

#    "securityGroupIngress1" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sg"
#        },
#        "CidrIp": "10.1.2.3/32",
#        "FromPort": 36,
#        "ToPort": 36,
#        "IpProtocol": "tcp"
#      }
#    },

#    "securityGroupIngress2" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sg"
#        },
#        "CidrIp" : ["1.2.3.4/32","3.4.5.6/24"],
#        "FromPort" : 36,
#        "ToPort" : 36,
#        "IpProtocol" : "tcp"
#      }
#    },

#    "securityGroupIngress3" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sg"
#        },
#        "CidrIp" : "1.2.3.4/24",
#        "FromPort" : 46,
#        "ToPort" : 46,
#        "IpProtocol" : "tcp"
#      }
#    },

#    "securityGroupIngress4" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sg"
#        },
#        "CidrIp" :  {"Ref":"somethingSpecial"},
#        "FromPort" : 46,
#        "ToPort" : 46,
#        "IpProtocol" : "tcp"
#      }
#    },

#    "securityGroupIngress5" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sg"
#        },
#        "CidrIp" :  ["1.2.3.4/32", {"Ref":"somethingSpecial"}],
#        "FromPort" : 46,
#        "ToPort" : 46,
#        "IpProtocol" : "tcp"
#      }
#    }
#  }
#}