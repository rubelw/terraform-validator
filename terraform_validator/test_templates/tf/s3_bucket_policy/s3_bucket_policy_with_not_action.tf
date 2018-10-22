# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_s3_bucket" "S3Bucket" {
  bucket = "fakebucketfakebucket"
}

resource "aws_s3_bucket_policy" "S3BucketPolicyWithNotAction" {
  bucket = "${aws_s3_bucket.S3Bucket.id}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "156460612806"
        ]
      },
      "NotAction": [
        "s3:Put*"
      ],
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

#    "S3BucketPolicyWithNotAction": {
#      "Type": "AWS::S3::BucketPolicy",
#      "Properties": {
#        "Bucket": {
#          "Ref": "S3Bucket"
#        },
#        "PolicyDocument": {
#          "Statement": [
#            {
#              "NotAction": [
#                "s3:Put*"
#              ],
#              "Effect": "Allow",
#              "Resource": "arn:aws:s3:::fakebucketfakebucket/*",
#              "Principal": {
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