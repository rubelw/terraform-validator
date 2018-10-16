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