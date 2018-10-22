# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_iam_role" "NotActionTrustRole" {
  name = "WildcardActionRole"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.example.json}"
}

data "aws_iam_policy_document" "example" {
  statement {
    effect = "allow"
    actions = ["s3:*"]
    resources = "*"
  }
  statement {
    effect = "allow"
    not_actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}