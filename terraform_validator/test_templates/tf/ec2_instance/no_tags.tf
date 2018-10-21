# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  tags {
    Name = "HelloWorld"
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
#      }
#    }
#  }
#}