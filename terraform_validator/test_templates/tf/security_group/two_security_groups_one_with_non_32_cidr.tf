# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_security_group" "some_group_desc" {
  name        = "some_group_desc"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-9f8e9dfa"

  ingress {
    from_port   = 34
    to_port     = 36
    protocol    = "tcp"
    cidr_blocks = ["10.1.2.3/32"]
  }

}

resource "aws_security_group" "some_group_desc2" {
  name        = "some_group_desc2"
  description = "some_group_desc2"
  vpc_id      = "vpc-9f8e9dfa"
  ingress {
    from_port   = 45
    to_port     = 46
    protocol    = "tcp"
    cidr_blocks = ["1.2.3.4/24"]
  }

  tags {
    Name = "allow_all"
  }
}


#{
#  "Resources": {
#    "sg": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc",
#        "SecurityGroupIngress" : {
#          "CidrIp" : "10.1.2.3/32",
#          "FromPort" : 34,
#          "ToPort" : 36,
#          "IpProtocol" : "tcp"
#        },
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    },

#    "sg2": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc2",
#        "SecurityGroupIngress" : [
#          {
#            "CidrIp" : "1.2.3.4/24",
#            "FromPort" : 45,
#            "ToPort" : 46,
#            "IpProtocol" : "tcp"
#          }
#        ],
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    }
#  }
#}