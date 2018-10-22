# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_s3_bucket" "S3Bucket" {
  bucket = "fakebucketfakebucket"
}

resource "aws_s3_bucket" "S3Bucket2" {
  bucket = "fakebucketfakebucket2"
}

resource "aws_s3_bucket" "S3Bucket3" {
  bucket = "fakebucketfakebucket3"
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
      "Principal": { "AWS": ["156460612806"] },
      "Action": "*",
      "Resource": "arn:aws:s3:::fakebucketfakebucket/*"
    } 
  ]
}
POLICY
}



resource "aws_s3_bucket_policy" "S3BucketPolicy2" {
  bucket = "${aws_s3_bucket.S3Bucket2.id}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY2",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Allow",
      "Principal": { "AWS": "*" },
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::fakebucketfakebucket2/*"
    }
  ]
}
POLICY
}



resource "aws_s3_bucket_policy" "S3BucketPolicy3" {
  bucket = "${aws_s3_bucket.S3Bucket3.id}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY3",
  "Statement": [
    {
      "Sid": "IPDeny",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::fakebucketfakebucket3/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption" : "AES256"
        }
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