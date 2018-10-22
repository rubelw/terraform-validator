# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_iam_user" "myuser2" {
  name = "myuser2"
}

resource "aws_iam_group" "group" {
  name = "test-group"
}

resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"

  users = [
    "${aws_iam_user.myuser2.name}"
  ]

  group = "${aws_iam_group.group.name}"
}


#{
#  "Resources": {
#    "myuser2": {
#      "Type": "AWS::IAM::User",
#      "Properties": {
#        "Groups": ["group1"]
#      }
#    }
#  }
#}