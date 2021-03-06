# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_ebs_volume" "NewVolume1" {
    availability_zone = "us-west-1c"
    size = 100
    type = "io1"
    iops = 100
    tags {
        Name = "HelloWorld"
    }
}

resource "aws_ebs_volume" "NewVolume2" {
    availability_zone = "us-west-1c"
    size = 100
    type = "io1"
    iops = 100
    encrypted = false
    tags {
        Name = "HelloWorld"
    }
}
