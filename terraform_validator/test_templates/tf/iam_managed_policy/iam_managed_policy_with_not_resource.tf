# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_iam_group" "SomeGroup" {
  name = "SomeGroups"
  path = "/"
}



resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  groups     = ["${aws_iam_group.SomeGroup.name}"]
  policy_arn = "${aws_iam_policy.CreateTestDBPolicy2.arn}"
}


resource "aws_iam_policy" "CreateTestDBPolicy2" {
  name        = "CreateTestDBPolicy2"
  path        = "/"
  description = "My test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "rds:CreateDBInstance",
      "NotResource": {
        "Fn::Join": [
          "",
          [
            "arn:aws:rds:",
            {
              "Ref": "AWS::Region"
            },
            ":",
            {
              "Ref": "AWS::AccountId"
            },
            ":db:test*"
          ]
        ]
      },
      "Condition": {
        "StringEquals": {
          "rds:DatabaseEngine": "mysql"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "rds:CreateDBInstance",
      "Resource": {
        "Fn::Join": [
          "",
          [
            "arn:aws:rds:",
            {
              "Ref": "AWS::Region"
            },
            ":",
            {
              "Ref": "AWS::Region"
            },
            ":db:test*"
          ]
        ]
      },
      "Condition": {
        "StringEquals": {
          "rds:DatabaseClass": "db.t2.micro"
        }
      }
    }
  ]
}
EOF
}


#{
#  "Resources": {
#    "CreateTestDBPolicy2": {
#      "Type": "AWS::IAM::ManagedPolicy",
#      "Properties": {
#        "Description": "Policy for creating a test database",
#        "Path": "/",
#        "PolicyDocument": {
#          "Version": "2012-10-17",
#          "Statement": [
#            {
#              "Effect": "Allow",
#              "Action": "rds:CreateDBInstance",
#              "NotResource": {
#                "Fn::Join": [
#                  "",
#                  [
#                    "arn:aws:rds:",
#                    {
#                      "Ref": "AWS::Region"
#                    },
#                    ":",
#                    {
#                      "Ref": "AWS::AccountId"
#                    },
#                    ":db:test*"
#                  ]
#                ]
#              },
#              "Condition": {
#                "StringEquals": {
#                  "rds:DatabaseEngine": "mysql"
#                }
#              }
#            },
#            {
#              "Effect": "Allow",
#              "Action": "rds:CreateDBInstance",
#              "Resource": {
#                "Fn::Join": [
#                  "",
#                  [
#                    "arn:aws:rds:",
#                    {
#                      "Ref": "AWS::Region"
#                    },
#                    ":",
#                    {
#                      "Ref": "AWS::Region"
#                    },
#                    ":db:test*"
#                  ]
#                ]
#              },
#              "Condition": {
#                "StringEquals": {
#                  "rds:DatabaseClass": "db.t2.micro"
#                }
#              }
#            }
#          ]
#        },
#        "Groups": [
#          "TestDBGroup"
#        ]
#      }
#    }
#  }
#}