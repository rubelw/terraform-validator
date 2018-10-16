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