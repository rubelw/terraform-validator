# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_iam_role" "NotPrincipalTrustRole" {
  name = "WildcardActionRole"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.example.json}"
}

data "aws_iam_policy_document" "example" {
  statement {
    effect = "allow"
    actions = ["s3:*"]
    resources = "*"
  }
  statement {
    effect = "allow"
    actions = ["sts:AssumeRole"]
    not_principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

}


#{
#  "AWSTemplateFormatVersion": "2010-09-09",
#  "Resources": {
#    "NotPrincipalTrustRole": {
#      "Type": "AWS::IAM::Role",
#      "Properties": {
#        "AssumeRolePolicyDocument": {
#          "Version": "2012-10-17",
#          "Statement": [
#            {
#              "Effect": "Allow",
#              "NotPrincipal": {
#                "Service": [
#                  "ec2.amazonaws.com"
#                ]
#              },
#              "Action": "sts:AssumeRole"
#            }
#          ]
#        },
#        "Path": "/",
#        "Policies": [
#          {
#            "PolicyName": "root",
#            "PolicyDocument": {
#              "Version": "2012-10-17",
#              "Statement": [
#                {
#                  "Effect": "Allow",
#                  "Action": "s3:*",
#                  "Resource": "*"
#                }
#              ]
#            }
#          }
#        ]
#      }
#    }
#  }
#}