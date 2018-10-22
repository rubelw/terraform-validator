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


#{
#  "Resources": {
#    "SomeGroup": {
#      "Type": "AWS::IAM::Group"
#    },

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  groups     = ["${aws_iam_group.SomeGroup.name}"]
  policy_arn = "${aws_iam_policy.WildcardActionPolicy.arn}"
}


resource "aws_iam_policy" "WildcardActionPolicy" {
  name        = "WildcardActionPolicy"
  path        = "/"
  description = "My test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "rds:CreateDBInstance",
        {
          "Fn::Join": [
            "",
            ["rds:Describe", "*", "Groups"]
          ]
        }
      ],
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
    }
  ]
}
EOF
}

#    "WildcardActionPolicy": {
#      "Type": "AWS::IAM::Policy",
#      "Properties": {
#        "PolicyName": "somePolicy",
#        "PolicyDocument": {
#          "Version": "2012-10-17",
#          "Statement": [
#            {
#              "Effect": "Allow",
#              "Action": [
#                "rds:CreateDBInstance",
#                {
#                  "Fn::Join": [
#                    "",
#                    ["rds:Describe", "*", "Groups"]
#                  ]
#                }
#              ],
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
#            }
#          ]
#        },
#        "Groups": [
#          {"Ref":"SomeGroup"}
#        ]
#      }
#    }
#  }
#}