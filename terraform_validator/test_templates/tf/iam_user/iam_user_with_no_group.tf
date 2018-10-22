# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_iam_user" "myuser2" {
  name = "myuser2"
}




#{
#  "Resources": {
#    "myuser2": {
#      "Type": "AWS::IAM::User"
#    }
#  }
#}