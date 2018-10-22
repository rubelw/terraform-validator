# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_s3_bucket" "S3BucketRead" {
  bucket = "fakebucketfakebucket"
  acl    = "public-read"

  tags {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "S3BucketReadWrite" {
  bucket = "fakebucketfakebucket2"
  acl    = "public-read-write"

  tags {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

#{
#  "Resources": {
#    "S3BucketRead" : {
#      "Type" : "AWS::S3::Bucket",
#      "Properties" : {
#        "BucketName" : "fakebucketfakebucket",
#        "AccessControl": "PublicRead"
#      }
#    },
#
#    "S3BucketReadWrite" : {
#      "Type" : "AWS::S3::Bucket",
#      "Properties" : {
#        "BucketName" : "fakebucketfakebucket2",
#        "AccessControl": "PublicReadWrite"
#      }
#    }
#  }
#}