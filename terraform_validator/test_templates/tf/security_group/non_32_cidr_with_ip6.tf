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