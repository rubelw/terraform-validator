# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  tags {
    Name = "HelloWorld"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "Main"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
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

resource "aws_network_interface" "test" {
  subnet_id       = "${aws_subnet.main.id}"
  private_ips     = ["10.0.0.50"]
  security_groups = ["${aws_security_group.allow_all.id}"]

  attachment {
    instance     = "${aws_instance.web.id}"
    device_index = 1
  }
}

#{
#  "Parameters": {
#    "subnetId": {
#      "Type": "String",
#      "Default": "subnet-4fd01116"
#    }
#  },

#  "Resources": {
#    "EC2I4LBA1": {
#      "Type": "AWS::EC2::Instance",
#      "Properties": {
#        "ImageId": "ami-6df1e514",
#        "InstanceType": "t2.micro",
#        "SubnetId": {
#          "Ref": "subnetId"
#        }
#      },
#      "Metadata": {
#        "AWS::CloudFormation::Authentication": {
#          "testBasic" : {
#            "type" : "basic",
#            "username" : "biff",
#            "password" : "badpassword",
#            "uris" : [ "http://www.example.com/test" ]
#          }
#        }
#      }
#    }
#  }
#}