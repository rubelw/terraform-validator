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