# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_ebs_volume" "NewVolume" {
    availability_zone = "us-west-1c"
    size = 100
    type = "io1"
    iops = 100
    encrypted = true
    tags {
        Name = "HelloWorld"
    }
}

