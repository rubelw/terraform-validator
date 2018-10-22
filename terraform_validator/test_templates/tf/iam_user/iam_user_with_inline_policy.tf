# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}




resource "aws_iam_user" "userWithInline" {
  name = "myuser2"
}

resource "aws_iam_policy" "policy" {
  name        = "somePolicy"
  path        = "/"
  description = "My test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:dosomething"
      ],
      "Effect": "Allow",
      "Resource": "arn:something"
    }
  ]
}
EOF
}


resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  users      = ["${aws_iam_user.userWithInline.name}"]
  policy_arn = "${aws_iam_policy.somePolicy.arn}"
}

#{
#  "Resources": {
#    "userWithInline": {
#      "Type": "AWS::IAM::User",
#      "Properties": {
#        "Groups": ["group1"],
#        "Policies": [
#          {
#            "PolicyDocument": {
#              "Effect": "Allow",
#              "Resource": "arn:something",
#              "Action": "s3:dosomething"
#            },
#            "PolicyName" : "somePolicy"
#          }
#        ]
#      }
#    }
#  }
#}