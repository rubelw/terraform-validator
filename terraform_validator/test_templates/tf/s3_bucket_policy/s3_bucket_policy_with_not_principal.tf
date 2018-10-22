# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_s3_bucket" "S3Bucket" {
  bucket = "fakebucketfakebucket"
}

resource "aws_s3_bucket_policy" "S3BucketPolicy" {
  bucket = "${aws_s3_bucket.S3Bucket.id}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Allow",
      "NotPrincipal": {
        "AWS": [
          "156460612806"
        ]
      },
      "Action": "*",
      "Resource": "arn:aws:s3:::fakebucketfakebucket/*"
    } 
  ]
}
POLICY
}

#{
#  "Resources": {
#    "S3Bucket" : {
#      "Type" : "AWS::S3::Bucket",
#      "Properties" : {
#        "BucketName" : "fakebucketfakebucket"
#      }
#    },

#    "S3BucketPolicy": {
#      "Type": "AWS::S3::BucketPolicy",
#      "Properties": {
#        "Bucket": {
#          "Ref": "S3Bucket"
#        },
#        "PolicyDocument": {
#          "Statement": [
#            {
#              "Action": [
#                "*"
#              ],
#              "Effect": "Allow",
#              "Resource": "arn:aws:s3:::fakebucketfakebucket/*",
#              "NotPrincipal": {
#                "AWS": [
#                  "156460612806"
#                ]
#              }
#            }
#          ]
#        }
#      }
#    }
#  }
#}