# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

variable "Username" {
  type = "string"
  default = "shameshame"

}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "sampleDbInstance"
  username             = "${var.Username}"
  parameter_group_name = "default.mysql5.7"
}


#{
#  "Parameters": {
#    "Username": {
#      "Type": "String",
#      "NoEcho": "true"
#    }
#  },
#  "Resources": {
#    "GoodDb": {
#      "Type": "AWS::RDS::DBInstance",
#      "Properties": {
#        "SourceDBInstanceIdentifier": "sampleDbInstance",
#        "MasterUsername": {
#          "Ref": "Username"
#        }
#      }
#    }
#  }
#}