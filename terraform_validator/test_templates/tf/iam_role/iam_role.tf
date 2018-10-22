# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_iam_role" "RootRole" {
  name = "RootRole"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.example.json}"
}

data "aws_iam_policy_document" "example" {
  statement {
    effect = "allow"
    actions = ["*"]
    resources = "*"
  }
  statement {
    effect = "allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  },
  statement {
    effect = "allow"
    actions = [
      "sts:AssumeRole",
    ],
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::324320755747:rootm"]
    }
  }

}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "${aws_iam_role.RootRole.name}"
}


#{
#  "AWSTemplateFormatVersion": "2010-09-09",
#  "Resources": {
#    "RootRole": {
#      "Type": "AWS::IAM::Role",
#      "Properties": {
#        "AssumeRolePolicyDocument": {
#          "Version" : "2012-10-17",
#          "Statement": [ {
#            "Effect": "Allow",
#            "Principal": {
#              "Service": [ "ec2.amazonaws.com" ],
#              "AWS" : "arn:aws:iam::324320755747:root"
#            },
#            "Action": ["sts:AssumeRole"]
#          } ]
#        },
#        "Path": "/",
#        "Policies": [ {
#          "PolicyName": "root",
#          "PolicyDocument": {
#            "Version" : "2012-10-17",
#            "Statement": [ {
#              "Effect": "Allow",
#              "Action": "*",
#              "Resource": "*"
#            } ]
#          }
#        } ]
#      }
#    },
#    "RootInstanceProfile": {
#      "Type": "AWS::IAM::InstanceProfile",
#      "Properties": {
#        "Path": "/",
#        "Roles": [ {
#          "Ref": "RootRole"
#        } ]
#      }
#    }
#  }
#}