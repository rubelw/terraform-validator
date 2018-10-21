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


}

resource "aws_security_group" "sg2" {
  name        = "sg2"
  description = "sg2"
  vpc_id      = "vpc-9f8e9dfa"


}


resource "aws_security_group_rule" "securityGroupIngress1" {
  type            = "ingress"
  from_port       = 34
  to_port         = 36
  protocol        = "tcp"
  cidr_blocks     = ["10.1.2.3/32"]

  security_group_id = "${aws_security_group.sg.id}"
}


resource "aws_security_group_rule" "securityGroupIngress2" {
  type            = "ingress"
  from_port       = 0
  to_port         = 36
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.sg2.id}"
}

resource "aws_security_group_rule" "securityGroupIngress3" {
  type            = "ingress"
  from_port       = 45
  to_port         = 46
  protocol        = "tcp"
  cidr_blocks     = ["1.2.3.4/32"]

  security_group_id = "${aws_security_group.sg2.id}"
}
#{
#  "Resources": {
#    "sg": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc",
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    },
#    "sg2": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc2",
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    },
#    "securityGroupIngress1" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sg"
#        },
#        "CidrIp": "10.1.2.3/32",
#        "FromPort": 34,
#        "ToPort": 36,
#        "IpProtocol": "tcp"
#      }
#    },
#    "securityGroupIngress2" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": {
#          "Fn::GetAtt": ["sg2", "GroupId"]
#        },
#        "CidrIp" : "0.0.0.0/0",
#        "FromPort" : 0,
#        "ToPort" : 36,
#        "IpProtocol" : "tcp"
#      }
#    },
#    "securityGroupIngress3" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": {
#          "Ref": "sg2"
#        },
#        "CidrIp" : "1.2.3.4/32",
#        "FromPort" : 45,
#        "ToPort" : 46,
#        "IpProtocol" : "tcp"
#      }
#    }
#  }
#}