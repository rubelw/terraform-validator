# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

variable "Password" {
  type = "string"
  default = "datpassword"

}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "${var.Password}"
  parameter_group_name = "default.mysql5.7"
}


#{
#  "Parameters": {
#    "Password": {
#      "Type": "String"
#    }
#  },
#  "Resources": {
#    "BadDb3": {
#      "Type": "AWS::RDS::DBInstance",
#      "Properties": {
#        "SourceDBInstanceIdentifier": "sampleDbInstance",
#        "MasterUserPassword": {
#          "Ref": "Password"
#        }
#      }
#    }
#  }
#}
