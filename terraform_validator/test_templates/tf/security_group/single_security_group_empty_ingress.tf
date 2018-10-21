# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}



resource "aws_security_group" "sg" {
  name        = "sg"
  description = "sg"
  vpc_id      = "vpc-9f8e9dfa"
}



#{
#  "Resources": {
#    "sg": {
#      "Type" : "AWS::EC2::SecurityGroup",
#      "Properties" : {
#        "GroupDescription" : "some_group_desc",
#        "VpcId" : "vpc-9f8e9dfa"
#      }
#    }
#  }
#}