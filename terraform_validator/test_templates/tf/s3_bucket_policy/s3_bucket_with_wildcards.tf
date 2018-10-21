# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_s3_bucket" "b" {
  bucket = "my_tf_test_bucket"
}

resource "aws_s3_bucket_policy" "b" {
  bucket = "${aws_s3_bucket.b.id}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::my_tf_test_bucket/*",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
      } 
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

#    "S3Bucket2" : {
#      "Type" : "AWS::S3::Bucket",
#      "Properties" : {
#        "BucketName" : "fakebucketfakebucket2"
#      }
#    },

#    "S3Bucket3" : {
#      "Type" : "AWS::S3::Bucket",
#      "Properties" : {
#        "BucketName" : "fakebucketfakebucket3"
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
#              "Principal": {
#                "AWS": [
#                  "156460612806"
#                ]
#              }
#            }
#          ]
#        }
#      }
#    },

#    "S3BucketPolicy2": {
#      "Type": "AWS::S3::BucketPolicy",
#      "Properties": {
#        "Bucket": {
#          "Ref": "S3Bucket2"
#        },
#        "PolicyDocument": {
#          "Statement": [
#            {
#              "Action": [
#                "s3:*"
#              ],
#              "Effect": "Allow",
#              "Resource": "arn:aws:s3:::fakebucketfakebucket2/*",
#              "Principal": {
#                "AWS": "*"
#              }
#            }
#          ]
#        }
#      }
#    },

#    "S3BucketPolicy3": {
#      "Type": "AWS::S3::BucketPolicy",
#      "Properties": {
#        "Bucket": {
#          "Ref": "S3Bucket3"
#        },
#        "PolicyDocument": {
#          "Statement": [
#            {
#              "Action": [
#                "s3:PutObject"
#              ],
#              "Effect": "Deny",
#              "Resource": "arn:aws:s3:::fakebucketfakebucket3/*",
#              "Principal": "*",
#              "Condition": {
#                "StringNotEquals": {
#                  "s3:x-amz-server-side-encryption" : "AES256"
#                }
#              }
#            }
#          ]
#        }
#      }
#    }
#  }
#}