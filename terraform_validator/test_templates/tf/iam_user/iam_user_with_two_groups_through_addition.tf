# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_iam_user" "lb" {
  name = "loadbalancer"
  path = "/system/"
}


resource "aws_iam_user_policy" "lb_ro" {
  name = "test"
  user = "${aws_iam_user.lb.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "myuser2" {
  user = "myuser2"
}


#{
#  "Resources": {
#    "myuser2": {
#      "Type": "AWS::IAM::User"
#    },


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

#    "addUserToGroup" : {
#      "Type" : "AWS::IAM::UserToGroupAddition",
#      "Properties" : {
#        "GroupName" : "group1",
#        "Users" : [ { "Ref" : "myuser2" } ]
#      }
#    },

resource "aws_iam_group" "group2" {
  name = "test-group"
}

resource "aws_iam_group_membership" "team2" {
  name = "tf-testing-group-membership"

  users = [
    "${aws_iam_user.myuser2.name}"
  ]

  group = "${aws_iam_group.group2.name}"
}
#    "addUserToGroup1" : {
#      "Type" : "AWS::IAM::UserToGroupAddition",
#      "Properties" : {
#        "GroupName" : "group2",
#        "Users" : [ { "Ref" : "myuser2" } ]
#      }
#    }
#  }
#}