# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_s3_bucket" "S3Bucket" {
  bucket = "fakebucketfakebucket2"

  tags {
    Name        = "ResourceOwner"
    Environment = "resourceowner"
  }
  tags {
    Name        = "DeployedBy"
    Environment = "deployedby"
  }
  tags {
    Name        = "Name"
    Environment = "name"
  }
  tags {
    Name        = "Project"
    Environment = "project"
  }
}

#{
#  "Resources": {
#    "S3Bucket" : {
#      "Type" : "AWS::S3::Bucket",
#      "Properties" : {
#        "BucketName" : "fakebucketfakebucket2",
#        "Tags" : [
#          {
#            "Key" : "ResourceOwner",
#            "Value" : "resourceowner"
#          },
#          {
#            "Key" : "DeployedBy",
#            "Value" : "deployedby"
#          },
#          {
#            "Key" : "Name",
#            "Value" : "name"
#          },
#          {
#            "Key" : "Project",
#            "Value" : "project"
#          }
#        ]
#      }
#    }
#  }
#}