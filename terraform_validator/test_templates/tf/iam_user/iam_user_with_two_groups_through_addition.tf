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

resource "aws_iam_access_key" "lb" {
  user = "${aws_iam_user.lb.name}"
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


#{
#  "Resources": {
#    "myuser2": {
#      "Type": "AWS::IAM::User"
#    },

#    "addUserToGroup" : {
#      "Type" : "AWS::IAM::UserToGroupAddition",
#      "Properties" : {
#        "GroupName" : "group1",
#        "Users" : [ { "Ref" : "myuser2" } ]
#      }
#    },

#    "addUserToGroup1" : {
#      "Type" : "AWS::IAM::UserToGroupAddition",
#      "Properties" : {
#        "GroupName" : "group2",
#        "Users" : [ { "Ref" : "myuser2" } ]
#      }
#    }
#  }
#}