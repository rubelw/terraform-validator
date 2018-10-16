# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}



resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = ["pl-12c4e678"]
  }
}
Basic usage with tags:

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_all"
  }
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
