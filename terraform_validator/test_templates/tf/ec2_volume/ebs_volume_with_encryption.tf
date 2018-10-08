# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_ebs_volume" "example" {
    availability_zone = "us-west-2a"
    size = 40
    tags {
        Name = "HelloWorld"
    }
}