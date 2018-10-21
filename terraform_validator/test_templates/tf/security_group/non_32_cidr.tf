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

  ingress {
    from_port   = 34
    to_port     =34
    protocol    = "tcp"
    cidr_blocks = ["10.1.2.0/24"]
  }

  egress {
    from_port       = 34
    to_port         = 34
    protocol        = "tcp"
    cidr_blocks     = ["10.1.2.3/32"]
  }
}

resource "aws_security_group" "sg2" {
  name        = "sg"
  description = "sg"
  vpc_id      = "vpc-9f8e9dfa"

  ingress {
    from_port   = 36
    to_port     =36
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
  }

  ingress {
    from_port   = 46
    to_port     =46
    protocol    = "tcp"
    cidr_blocks = ["1.2.3.4/32"]
  }
  ingress {
    from_port   = 33
    to_port     =33
    protocol    = "tcp"
    cidr_blocks = ["${var.somethingSpecial}"]
  }
  egress {
    from_port       = 34
    to_port         = 34
    protocol        = "tcp"
    cidr_blocks     = ["10.1.2.3/32"]
  }
}



resource "aws_security_group" "sg3" {
  name        = "sg"
  description = "sg"
  vpc_id      = "vpc-9f8e9dfa"

  ingress {
    from_port   = 33
    to_port     =33
    protocol    = "tcp"
    cidr_blocks = ["${var.somethingSpecial}"]
  }

  egress {
    from_port       = 34
    to_port         = 34
    protocol        = "tcp"
    cidr_blocks     = ["10.1.2.3/32"]
  }
}


resource "aws_security_group" "sg4" {
  name        = "sg"
  description = "sg"
  vpc_id      = "vpc-9f8e9dfa"

  ingress {
    from_port   = 33
    to_port     =33
    protocol    = "tcp"
    cidr_blocks = ["${var.somethingSpecial}","1.2.3.4/32"]
  }

  egress {
    from_port       = 34
    to_port         = 34
    protocol        = "tcp"
    cidr_blocks     = ["10.1.2.3/32"]
  }
}
#{
#  "Parameters": {
#    "somethingSpecial": {
#      "Type": "String"
#    }
#  },

#  "Resources": {
#    "sg": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc",
#        "SecurityGroupIngress" : {
#          "CidrIp" : "10.1.2.0/24",
#          "FromPort" : 34,
#          "ToPort" : 34,
#          "IpProtocol" : "tcp"
#        },
#        "SecurityGroupEgress" : {
#          "CidrIp": "10.1.2.3/32",
#          "FromPort": 34,
#          "ToPort": 34,
#          "IpProtocol": "tcp"
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
#            "CidrIp" : "10.2.0.0/16",
#            "FromPort" : 36,
#            "ToPort" : 36,
#            "IpProtocol" : "tcp"
#          },
#          {
#            "CidrIp" : "1.2.3.4/32",
#            "FromPort" : 46,
#            "ToPort" : 46,
#            "IpProtocol" : "tcp"
#          },
#          {
#            "CidrIp" : {"Ref":"somethingSpecial"},
#            "FromPort" : 33,
#            "ToPort" : 33,
#            "IpProtocol" : "tcp"
#          }
#        ],
#        "SecurityGroupEgress" : {
#          "CidrIp": "10.1.2.3/32",
#          "FromPort": 34,
#          "ToPort": 34,
#          "IpProtocol": "tcp"
#        },
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    },

#    "sg3": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc2",
#        "SecurityGroupIngress" : {
#          "CidrIp" : {"Ref":"somethingSpecial"},
#          "FromPort" : 33,
#          "ToPort" : 33,
#          "IpProtocol" : "tcp"
#        },
#        "SecurityGroupEgress" : {
#          "CidrIp": "10.1.2.3/32",
#          "FromPort": 34,
#          "ToPort": 34,
#          "IpProtocol": "tcp"
#        },
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    },

#    "sg4": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc2",
#        "SecurityGroupIngress" : {
#          "CidrIp" : [{"Ref":"somethingSpecial"},"1.2.3.4/32"],
#          "FromPort" : 33,
#          "ToPort" : 33,
#          "IpProtocol" : "tcp"
#        },
#        "SecurityGroupEgress" : {
#          "CidrIp": "10.1.2.3/32",
#          "FromPort": 34,
#          "ToPort": 34,
#          "IpProtocol": "tcp"
#        },
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    }
#  }
#}