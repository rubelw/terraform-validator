# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_iam_user" "TestUser" {
  name = "TestUser"
  path = "/"
}



#{
#  "Resources": {
#    "TestUser": {
#      "Type": "AWS::IAM::User"
#    },


resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  users     = ["${aws_iam_group.TestUser.name}"]
  policy_arn = "${aws_iam_policy.DirectPolicy.arn}"
}


resource "aws_iam_policy" "DirectPolicy" {
  name        = "DirectPolicy"
  path        = "/"
  description = "My test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "rds:CreateDBInstance",
      "Effect": "Allow",
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
      "NotAction": "rds:CreateDBInstance",
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


#    "DirectPolicy": {
#      "Type": "AWS::IAM::Policy",
#      "Properties": {
#        "PolicyName": "somePolicy",
#        "PolicyDocument": {
#          "Version": "2012-10-17",
#          "Statement": [
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
#              "NotAction": "rds:CreateDBInstance",
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
#        "Users": [
#          {"Ref":"TestUser"}
#        ]
#      }
#    }
#  }
#}