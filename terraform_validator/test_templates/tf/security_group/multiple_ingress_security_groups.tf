# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

variable "jumpCIDR" {
  type = "string"
  default = "0.0.0.0/16"

}

variable "otherCIDR" {
  type = "string"
  default = "0.0.0.0/16"

}

resource "aws_security_group" "emrSecurityGroup" {
  name        = "emrSecurityGroup"
  description = "emrSecurityGroup"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.jumpCIDR}"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.otherCIDR}"]
  }

  egress {
    from_port       = -1
    to_port         = -1
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


resource "aws_security_group_rule" "emrSecurityGroupIngress" {
  type            = "ingress"
  from_port       = -1
  to_port         = -1
  protocol        = "-1"
  cidr_blocks     = ["1.2.3.5/32"]
  source_security_group_id = "${aws_security_group.emrSecurityGroup.id}"
  security_group_id = "${aws_security_group.emrSecurityGroup.id}"
}


#{
#    "AWSTemplateFormatVersion": "2010-09-09",
#    "Description": "Security Groups",
#    "Parameters": {
#        "jumpCIDR": {
#            "Description": "Jump",
#            "Type": "String"
#        },
#        "otherCIDR": {
#            "Description": "Another Cidr",
#            "Default": "0.0.0.0/16",
#            "Type": "String"
#        }
#    },
#    "Resources": {
#        "emrSecurityGroup" : {
#            "Type" : "AWS::EC2::SecurityGroup",
#            "Properties" : {
#                "GroupDescription" : "Allow traffic",
#                "GroupName" : "emr-sg",
#                "VpcId" : {"Fn::ImportValue" : "ProdVPCV1"},
#                "SecurityGroupIngress" : [
#                    {
#                    "IpProtocol" : "tcp",
#                    "FromPort" : "22",
#                    "ToPort" : "22",
#                    "CidrIp" : { "Ref": "otherCIDR" }
#                    },
#                    {
#                    "IpProtocol" : "tcp",
#                    "FromPort" : "22",
#                    "ToPort" : "22",
#                    "CidrIp" : { "Ref": "jumpCIDR" }
#                    }
#                ],
#                "SecurityGroupEgress" : [{
#                    "IpProtocol" : "-1",
#                    "FromPort" : "-1",
#                    "ToPort" : "-1",
#                    "CidrIp" : "0.0.0.0/0"
#                }]
#            }
#        },
#        "emrSecurityGroupIngress": {
#            "Type" : "AWS::EC2::SecurityGroupIngress",
#            "Properties" : {
#                "FromPort" : "-1",
#                "ToPort" : "-1",
#                "GroupId" : { "Ref": "emrSecurityGroup" },
#                "IpProtocol" : "-1",
#                "SourceSecurityGroupId" : { "Ref": "emrSecurityGroup" }
#            }
#        }
#    }
#}
